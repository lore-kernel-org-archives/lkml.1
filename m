Return-Path: <linux-kernel-owner+w=401wt.eu-S1764314AbXEURMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764314AbXEURMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 13:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbXEURMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 13:12:15 -0400
Received: from nicole.bmts.com ([216.183.128.225]:40733 "EHLO nicole.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758565AbXEURMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 13:12:14 -0400
Date: Mon, 21 May 2007 13:10:55 -0400
From: Mike Houston <mikeserv@bmts.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
Message-Id: <20070521131055.0017404f.mikeserv@bmts.com>
In-Reply-To: <20070521084549.61a1aa71@freepuppy>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<20070520170506.814a38d9.mikeserv@bmts.com>
	<20070521084549.61a1aa71@freepuppy>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2007 08:45:49 -0700
Stephen Hemminger <shemminger@linux-foundation.org> wrote:

> It's almost certainly a problem with the BIOS and hardware (not a
> sky2) driver issue. Since there are many similar boards and
> configurations, I made the decision not to enforce restrictions in
> the driver.

>> May 20 15:57:48 cramit kernel: sky2 0000:04:00.0: v1.14 addr
>> 0xf8000000 irq 16 Yukon-EC Ultra (0xb4) rev 2

Thank you for your answer. I was half wondering if that was the case
after staring at those log messages several more times. I don't
understand hardware at the low level but got thinking maybe interrupt
routing issue. There's an Nvidia PCI Express card in there that gets
IRQ 16, though it was not initialized by a driver at the time. (plain
old VGA console after fresh cold boot... no framebuffer, no X, no
nvidia module). I guess some things don't share well.

It works well in that other OS that came with the hardware, but
that's beside the point.

Mike Houston
