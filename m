Return-Path: <linux-kernel-owner+w=401wt.eu-S934298AbXJOUH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbXJOUH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933491AbXJOUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:07:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35897 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933095AbXJOUHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:07:05 -0400
Date: Mon, 15 Oct 2007 21:08:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Boaz Harrosh <bharrosh@panasas.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
Message-ID: <20071015210837.311f058a@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0710151232430.6887@woody.linux-foundation.org>
References: <20071015165534.GA17833@elte.hu>
	<alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
	<4713A9FA.4050209@garzik.org>
	<4713B4E7.2050001@panasas.com>
	<20071015192703.GA7279@elte.hu>
	<alpine.LFD.0.999.0710151232430.6887@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 12:38:06 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 15 Oct 2007, Ingo Molnar wrote:
> > 
> > heh. Incidentally i was thinking about using KVM for automated testing. 
> 
> Using emulators to test device drivers is almost certain to be pointless.

For some things. I do it a bit because you can use it to fake
failures that are tricky to do in the real world. It won't tell you the
driver works but its suprisingly good for testing for races (forcing IRQ
delivery at specific points), buggy hardware you don't posess, and things
like media failures and timeouts your real hardware refuses to do.

Alan
