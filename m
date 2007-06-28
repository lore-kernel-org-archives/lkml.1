Return-Path: <linux-kernel-owner+w=401wt.eu-S1765064AbXF1Rx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765064AbXF1Rx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 13:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762051AbXF1RxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 13:53:20 -0400
Received: from mail.trixing.net ([87.230.125.58]:41272 "EHLO mail.trixing.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761309AbXF1RxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 13:53:19 -0400
Message-ID: <4683F587.5070507@l4x.org>
Date: Thu, 28 Jun 2007 19:53:11 +0200
From: Jan Dittmer <jdi@l4x.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070329 Thunderbird/1.5.0.10 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Midhun Agnihotram <agnimidhun@gmail.com>
CC: linux-kernel@vger.kernel.org, drzeus-mmc@drzeus.cx
References: <4dde4acb0706261146s5906d8f3vb787d5aecb429116@mail.gmail.com>	 <4dde4acb0706281000p180d0066s11a21afe17336fb4@mail.gmail.com> <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
In-Reply-To: <4dde4acb0706281008h2241f4c4nef18dc130bfe6fdd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.195
X-SA-Exim-Mail-From: jdi@l4x.org
Subject: Re: Mounting MMC card
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on mail.trixing.net)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Midhun Agnihotram wrote:
> Sorry for resending. I dont know if my previous mail has reached the
> list with "Fwd" in the subject line. I am pretty sure there must a
> filter in Majordomo to discard forwards. Actually I am resending the
> mail I had sent to Linux-Arm-Kernel.

The mail came already through the first time. It may take a while.
There are a _lot_ of subscribers and a _lot_ of mails.

> brwxrwxrwx    1 0        0        254,   0 Jun 26  2007 mmcblk0
> brwxrwxrwx    1 0        0        254,   1 Jun 26  2007 mmcblk0p0
> brwxrwxrwx    1 0        0        254,   2 Jun 26  2007 mmcblk0p1
> brwxrwxrwx    1 0        0        254,   3 Jun 26  2007 mmcblk0p2
> brwxrwxrwx    1 0        0        254,   4 Jun 26  2007 mmcblk0p3
> 
>     How do I access the MMC card data now? If I try to mount it,
> busybox doesnot mount it.
> 
> # mount /dev/mmcblk0p0 /mnt/mmc
> mount: mounting /dev/mmcblk0p0 on /mnt/mmc failed
> 
>   I have tried with /dev/mmcblk0p0, mmcblk0p1,etc. But of no use. How

Try to mount mmcblk0 and/or try fdisk and look at the partition
table. dmesg output would also be helpful (after the failed mount).

Jan
