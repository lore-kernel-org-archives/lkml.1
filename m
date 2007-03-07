Return-Path: <linux-kernel-owner+w=401wt.eu-S1422995AbXCGSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422995AbXCGSrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422993AbXCGSrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:47:49 -0500
Received: from www.osadl.org ([213.239.205.134]:50716 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422995AbXCGSrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:47:47 -0500
Subject: Re: + stupid-hack-to-make-mainline-build.patch added to -mm tree
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dan Hecht <dhecht@vmware.com>,
       Zachary Amsden <zach@vmware.com>, akpm@linux-foundation.org, ak@suse.de,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>
In-Reply-To: <45EF044C.2080307@goop.org>
References: <45EDD82F.90204@vmware.com>
	 <1173225182.24738.507.camel@localhost.localdomain>
	 <45EE0628.1080108@goop.org> <45EE08E8.2020008@vmware.com>
	 <1173228544.24738.514.camel@localhost.localdomain>
	 <45EE0D10.7070807@vmware.com>
	 <1173230305.24738.529.camel@localhost.localdomain>
	 <45EE1EA3.90803@vmware.com>
	 <1173256666.24738.576.camel@localhost.localdomain>
	 <45EEF966.6060902@goop.org> <20070307175232.GB31371@elte.hu>
	 <45EF044C.2080307@goop.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 19:53:55 +0100
Message-Id: <1173293636.24738.670.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 10:28 -0800, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > /For you/ it's certainly no big deal, you dont have to fix it up and you 
> > dont have to keep it flexible ;)
> >   
> 
> How flexible does it need to be?  Its a simple time source and event
> driver.  How flexible does the pit driver need to be?  It's just a small
> leaf node hanging off a large existing piece of kernel infrastructure.
> 
> > and really, i'm not expecting miracles, i've never seen any hardware 
> > vendor argue /against/ support for their own hardware =B-)
> >   
> 
> And since when has it been kernel policy to argue against including a
> well written, self-contained, vendor-provided driver for a piece of
> hardware?

The difference is that we have not much influence on the design
decisions of silicon vendors. We usually see them when the shit already
has been morphed into solid silicon.

Software emulated silicon _IS_ actually under our control. And we want
to have it as sane as possible.

	tglx


