Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbXH1GuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbXH1GuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXH1GuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:50:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:53420 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbXH1Gt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:49:59 -0400
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Zachary Amsden <zach@vmware.com>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <46CBC842.4070100@vmware.com>
References: <46CBC842.4070100@vmware.com>
Content-Type: text/plain
Date: Mon, 27 Aug 2007 19:54:13 +0200
Message-Id: <1188237253.5972.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-21 at 22:23 -0700, Zachary Amsden wrote:
> In general, I/O in a virtual guest is subject to performance problems.  
> The I/O can not be completed physically, but must be virtualized.  This 
> means trapping and decoding port I/O instructions from the guest OS.  
> Not only is the trap for a #GP heavyweight, both in the processor and 
> the hypervisor (which usually has a complex #GP path), but this forces 
> the hypervisor to decode the individual instruction which has faulted.  
> Worse, even with hardware assist such as VT, the exit reason alone is 
> not sufficient to determine the true nature of the faulting instruction, 
> requiring a complex and costly instruction decode and simulation.

 .../...

How about userland ? Things like X do IO's typically... You still need
to trap/emulate for these no ?

Cheers,
Ben.

