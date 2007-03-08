Return-Path: <linux-kernel-owner+w=401wt.eu-S1030206AbXCHIO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030206AbXCHIO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:14:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030218AbXCHIO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:14:58 -0500
Received: from mta2.cl.cam.ac.uk ([128.232.0.14]:44066 "EHLO mta2.cl.cam.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030206AbXCHIO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:14:57 -0500
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Thu, 08 Mar 2007 08:15:15 +0000
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <akpm@linux-foundation.org>
Message-ID: <C2157693.381A%Keir.Fraser@cl.cam.ac.uk>
Thread-Topic: + stupid-hack-to-make-mainline-build.patch added to -mm tree
Thread-Index: AcdhWeZ4JPOPLs1NEduPKQAWy6hiGQ==
In-Reply-To: <20070308080131.GB9295@elte.hu>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/3/07 08:01, "Ingo Molnar" <mingo@elte.hu> wrote:

> you are obsessed with avoiding a hypercall, but why? Granted it's slow
> especially on things like SVN/VMX, but it's not fundamentally slow. We
> definitely do not want to design our whole APIs and abstractions around
> the temporary notion that 'hypercalls are slow'. I'd expect hypercalls
> to be put into silicon just as much as SYSENTER was put into silicon.

If syscalls are already so fast, why does Linux have vgettimeofday()?

 -- Keir


