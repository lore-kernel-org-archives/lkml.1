Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZHQI5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZHQI5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757455AbZHQI5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:57:47 -0400
Received: from mail.atheros.com ([12.36.123.2]:42787 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZHQI5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:57:46 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19081.7071.596267.497541@gargle.gargle.HOWL>
Date: Mon, 17 Aug 2009 14:28:07 +0530
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Jouni Malinen <Jouni.Malinen@atheros.com>,
       Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>
Subject: 2.6.31-rc5-git9 -- [<c10562ad>] __report_bad_irq+0x2e/0x6f
In-Reply-To: <a44ae5cd0908142242s623b7068m1c7bca4388d32e04@mail.gmail.com>
References: <a44ae5cd0908142242s623b7068m1c7bca4388d32e04@mail.gmail.com>
X-Mailer: VM 8.0.12 under 23.1.1 (x86_64-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> Running Ubuntu Karmic (pre-9.10) updated today, I hit this resuming from suspend.
> Afterwards, I had to rmmod ath9k & ath, and then modprobe them to get my WIFI working again.
> 
> [  600.778140] hub 1-0:1.0: port 8, status 0503, change 0000, 480 Mb/s
> [  600.799650] done.
> [  602.489540] irq 19: nobody cared (try booting with the "irqpoll" option)
> [  602.489558] Pid: 3314, comm: gnome-screensav Not tainted 2.6.31-rc5-git9 #5
> [  602.489567] Call Trace:
> [  602.489587]  [<c10562ad>] __report_bad_irq+0x2e/0x6f
> [  602.489600]  [<c10563e3>] note_interrupt+0xf5/0x14e
> [  602.489611]  [<c105539a>] ? handle_IRQ_event+0x8a/0x95
> [  602.489624]  [<c1056925>] handle_fasteoi_irq+0x8a/0xad
> [  602.489636]  [<c105689b>] ? handle_fasteoi_irq+0x0/0xad
> [  602.489644]  <IRQ>  [<c100454b>] ? do_IRQ+0x41/0x95
> [  602.489665]  [<c10030b5>] ? common_interrupt+0x35/0x3c
> [  602.489673] handlers:
> [  602.489679] [<f8389124>] (usb_hcd_irq+0x0/0x71 [usbcore])
> [  602.489733] [<f84940d2>] (ath_isr+0x0/0x12e [ath9k])
> [  602.489769] Disabling IRQ #19
> [  602.586887]

A patch fixing this issue is in wireless-testing.
URL: http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=6bffc3e18e342c5cc7dcf7207e15ec7a027419e8

To pull the latest wireless code, you can use compat-wireless.
Check http://wireless.kernel.org/en/users/Download

Sujith
