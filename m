Return-Path: <linux-kernel-owner+w=401wt.eu-S932526AbXJOUSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526AbXJOUSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764534AbXJOURx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:17:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764416AbXJOURv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:17:51 -0400
Date: Mon, 15 Oct 2007 13:15:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Boaz Harrosh <bharrosh@panasas.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
In-Reply-To: <20071015210837.311f058a@the-village.bc.nu>
Message-ID: <alpine.LFD.0.999.0710151312500.6887@woody.linux-foundation.org>
References: <20071015165534.GA17833@elte.hu>
 <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
 <4713A9FA.4050209@garzik.org> <4713B4E7.2050001@panasas.com>
 <20071015192703.GA7279@elte.hu> <alpine.LFD.0.999.0710151232430.6887@woody.linux-foundation.org>
 <20071015210837.311f058a@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Alan Cox wrote:
> 
> For some things. I do it a bit because you can use it to fake
> failures that are tricky to do in the real world. It won't tell you the
> driver works but its suprisingly good for testing for races (forcing IRQ
> delivery at specific points), buggy hardware you don't posess, and things
> like media failures and timeouts your real hardware refuses to do.

Heh. I do agree that you likely find bugs, even if quite often it's 
exactly because the behaviour is something that will never happen on real 
hardware.

But failure testing is very useful - I forget who it was who debugged some 
driver by taking a CD and just scrathing it mercilessly to induce read 
errors ;)

Having a really *bad* HW emulator can certainly work that way too, even if 
it also would probably end up hitting just a few of the potential error 
paths..

			Linus
