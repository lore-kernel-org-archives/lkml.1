Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbYAJKD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbYAJKD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759179AbYAJKDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:03:12 -0500
Received: from rosi.naasa.net ([212.8.0.13]:43794 "EHLO rosi.naasa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159AbYAJKDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:03:10 -0500
From: Joerg Platte <lists@naasa.net>
Reply-To: jplatte@naasa.net
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 10 Jan 2008 11:03:05 +0100
User-Agent: KMail/1.9.7
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <200801071151.11200.lists@naasa.net> <200801100937.56145.lists@naasa.net> <399954652.04868@ustc.edu.cn>
In-Reply-To: <399954652.04868@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801101103.06688.lists@naasa.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 10. Januar 2008 schrieb Fengguang Wu:
> > problem, because the iowait problem disappeared today after the regular
> > Debian update. I'll try to install the old package versions to make it
> > show up again. Maybe that helps to debug it.
>
> Thank you. I'm running sid, ext2 as rootfs now ;-)

The error is back and I'm getting thousands of messages like this with the 
patched kernel:

mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3936 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3936 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3937 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3937 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3937 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3937 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3937 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3937 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3937 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3937 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3938 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3938 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3939 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3939 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3939 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3939 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3939 0 0 wc _M 
tw 1024 sk 2
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3939 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(146) 21115 global 3939 0 0 wc _M 
tw 1024 sk 0
requeue_io 301: inode 81441 size 0 at 08:07(sda7)
mm/page-writeback.c 668 wb_kupdate: pdflush(147) 17451 global 3939 0 0 wc _M 
tw 1024 sk 2

regards,
Jörg

-- 
PGP Key: send mail with subject 'SEND PGP-KEY' PGP Key-ID: FD 4E 21 1D
PGP Fingerprint: 388A872AFC5649D3 BCEC65778BE0C605
