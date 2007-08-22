Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbXHVG0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbXHVG0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 02:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbXHVG0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 02:26:35 -0400
Received: from ozlabs.org ([203.10.76.45]:40810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbXHVG0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 02:26:34 -0400
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Zachary Amsden <zach@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <46CBCADF.2070400@qumranet.com>
References: <46CBC842.4070100@vmware.com>  <46CBCADF.2070400@qumranet.com>
Content-Type: text/plain
Date: Wed, 22 Aug 2007 16:25:56 +1000
Message-Id: <1187763956.6174.48.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 08:34 +0300, Avi Kivity wrote:
> Zachary Amsden wrote:
> > This patch provides hypercalls for the i386 port I/O instructions,
> > which vastly helps guests which use native-style drivers.  For certain
> > VMI workloads, this provides a performance boost of up to 30%.  We
> > expect KVM and lguest to be able to achieve similar gains on I/O
> > intensive workloads.
> 
> Won't these workloads be better off using paravirtualized drivers? 
> i.e., do the native drivers with paravirt I/O instructions get anywhere
> near the performance of paravirt drivers?

This patch also means I can kill off the emulation code in
drivers/lguest/core.c, which is a real relief.

Cheers,
Rusty.


