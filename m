Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYHJRZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYHJRZn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbYHJRZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:25:35 -0400
Received: from wmproxy2-g27.free.fr ([212.27.42.92]:8545 "EHLO
	wmproxy2-g27.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbYHJRZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:25:34 -0400
Date: Sun, 10 Aug 2008 19:25:33 +0200 (CEST)
From: mengualjeanphi@free.fr
To: linux-kernel@vger.kernel.org
Message-ID: <133482356.7113251218389133818.JavaMail.root@spooler9-g27.priv.proxad.net>
Subject: Boot problem
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 5.0.5_GA_2166.UBUNTU6_64 (zclient/5.0.5_GA_2166.UBUNTU6_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I try building an LFS system for 64 bits. But now I've a problem, linked to the kernel.

I've a motherboard ASRock ALiveNF6P-VSTA. Instead of its port IDE, I use a PCI controller where are connected my disks.

On the livecd lfs, sometimes disks are named hda, hdb... sometimes hdc, hdd... Strange.

When I boot on my system, I get: "root fs not found on "hdc1"" (or hda1, according what I said in fstab and menu.lst of grub). Grub is built in static release I found on a cvs repository of clfs or lfs.

Other details:

-I tried kernel 2.6.22.5 and 26.2, in both menuconfig, when I choose Bus support then PCI support, I don't have PCI access (I should have it if I follow results of my searches).

-I prefer configuring the kernel instead of modifying bios, where access is hard for physical reasons.

-I believed unstability in naming drives could be problemajic for the kernel. So in fstab I put UUID=b1039c23-7359-4763-8213-38a862509bfe  /      ext3   defaults  1 2

in menu.lst, kernel /boot/lfskernel-2.6.22.5 root=UUID=b1039c23-7359-4763-8213-38a862509bfe

I disabled mmconfig.

An idea please? I guess it's linked to kernel and hardware issues, but I'd like to determine what.

Thanks very much for your answer. I'm really lost in this situation and you're the last who can help me. Or tell me who can. If you can't I'll try installing another distro linux, but I'd rather find a solution.

Best regards, JP
