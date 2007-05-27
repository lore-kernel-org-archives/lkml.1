Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbXE0RKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbXE0RKk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 13:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXE0RKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 13:10:33 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:35548 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396AbXE0RKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 13:10:32 -0400
Date: Sun, 27 May 2007 19:09:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Miller <davem@davemloft.net>
cc: sparclinux@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Linux always started with 9600 8N1
In-Reply-To: <Pine.LNX.4.61.0705271816310.7344@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0705271909140.7344@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705261649590.7344@yvahk01.tjqt.qr>
 <20070526.154745.30164056.davem@davemloft.net> <Pine.LNX.4.61.0705271816310.7344@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 27 2007 18:44, Jan Engelhardt wrote:
>On May 26 2007 15:47, David Miller wrote:
>>> I have set the OBP to run at 115200, also set agetty on ttyS0 to do the 
>>> same, and also added console=ttyS0,115200 to silo.conf (and also tried 
>>> console=ttyS0,115200n8). But! Linux still gives me 9600 8N1. The ominous 
>>> double screen blanking (why is that done anyway?) already takes place 
>>> with 9600. I smell a bug. What do you think?
>>
>>The code in drivers/serial/suncore.c:sunserial_console_termios()
>>should be parsing your OBP settings, add some tracing and see why it
>>isn't working.
>>
>>Please track the bug down for us, thanks :-)
>
>Just why did no one get a kernel oops? After all, the code tried to
>write to constant memory.
>
>This is the first patch of two. There is yet another section of Linux 
>code that runs in 9600-only, and I need to figure out which.

Ok no second patch. The issue (double blanking at boot, which I presumed
also ran at 9600) was recently fixed too.


	Jan
-- 
