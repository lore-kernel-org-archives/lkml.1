Return-Path: <linux-kernel-owner+w=401wt.eu-S2992469AbXCGWIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992469AbXCGWIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992473AbXCGWIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:08:22 -0500
Received: from www.osadl.org ([213.239.205.134]:40077 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992469AbXCGWIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:08:20 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Dan Hecht <dhecht@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EF2FFE.7010705@vmware.com>
References: <200703060654.l266sVxr014860@shell0.pdx.osdl.net>
	 <45ED16D2.3000202@vmware.com> <20070306084258.GA15745@elte.hu>
	 <20070306084647.GA16280@elte.hu>  <45ED2C82.3080008@vmware.com>
	 <1173178774.24738.311.camel@localhost.localdomain>
	 <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org>  <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org>
	 <1173300032.24738.750.camel@localhost.localdomain>
	 <45EF2991.1020204@goop.org>
	 <1173303639.24738.814.camel@localhost.localdomain>
	 <45EF2FFE.7010705@vmware.com>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 23:14:30 +0100
Message-Id: <1173305670.24738.849.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 13:34 -0800, Dan Hecht wrote:
> On 03/07/2007 01:40 PM, Thomas Gleixner wrote:
> > On Wed, 2007-03-07 at 13:07 -0800, Jeremy Fitzhardinge wrote:
> > That would certainly be ideal.  We'll look at the xen, vmi, lguest and
> >> kvm paravirtualized time models and see how much they really have in
> >> common.  I'm a bit curious about how vmi's time events make their way
> >> back into the system.
> > 
> > By the crude mechanism I'm fighting.
> >
> 
> Hmm?  They make there way back via interrupts.  How is that crude?

Simply because you _ABUSE_ timer_init_hook() to set it up. Keep it self
contained and do not impose restrictions on the kernel core code, which
we have to maintain.

	tglx


