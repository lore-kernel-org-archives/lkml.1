Return-Path: <linux-kernel-owner+w=401wt.eu-S933347AbXAaUMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbXAaUMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933348AbXAaUMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:12:15 -0500
Received: from www.osadl.org ([213.239.205.134]:34853 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933347AbXAaUMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:12:14 -0500
Subject: Re: Linux 2.6.20-rc6 - sky2 resume breakage
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Jeff Garzik <jeff@garzik.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45C0D765.4010709@garzik.org>
References: <20070129154518.40b0b3d3@freekitty>
	 <Pine.LNX.4.64.0701291609180.3611@woody.linux-foundation.org>
	 <20070129161626.33277eb1@freekitty>
	 <Pine.LNX.4.64.0701291623360.3611@woody.linux-foundation.org>
	 <20070130065457.GA23390@elte.hu> <45BEF61F.7000400@garzik.org>
	 <20070130075325.GA591@elte.hu> <45BEFBB2.8090402@garzik.org>
	 <20070130080830.GC2840@elte.hu> <45C0B570.4000000@garzik.org>
	 <20070131173832.GA13653@elte.hu>  <45C0D765.4010709@garzik.org>
Content-Type: text/plain
Date: Wed, 31 Jan 2007 21:13:04 +0100
Message-Id: <1170274384.29240.198.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 12:52 -0500, Jeff Garzik wrote:
> Ingo Molnar wrote:
> >  19:    2413090          0   IO-APIC-fasteoi   uhci_hcd:usb2, libata
> 
> Yep, that's a good candidate for such experiments :)

Happens to be the same thing, which causes a stale interrupt on the
second suspend/resume cycle.

	tglx


