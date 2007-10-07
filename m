Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbXJGQo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbXJGQo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXJGQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:44:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38964 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbXJGQoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:44:19 -0400
Date: Sun, 7 Oct 2007 18:44:18 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
In-Reply-To: <20071007163824.GA30063@elte.hu>
Message-ID: <Pine.LNX.4.64.0710071841360.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
 <20071007163824.GA30063@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 18:38, Ingo Molnar wrote:
>
>minor fix: i had to use the slightly modified patch below instead of the 
>one you posted, so that the second patch applies fine.

What is it that you changed? The printk patches are right at the front,
so there should not be any fuzz or offsets (might vary when
not at Linus's git top).

18:42 ichi:/ws/linux/linux-2.6.23 > head -n6 patches/series
checkpatch1.diff
checkpatch2.diff
checkfiles.diff
xt_TCPOPTSTRIP.diff
vt-printk-color.diff
vt-printk-color-per-loglevel.diff

>Color output is 
>just fine with this plus your #2 one applied. Adding 
>vt.printk_color=0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08 to the boot line 
>worked as expected.

Use decimal if feasible. (vt.printk_color=1,2,3,4,5,6,7,8)
The maximum command line still seems to be 255 on i386,
as I noticed while trying to replace the VGA color table :-(

