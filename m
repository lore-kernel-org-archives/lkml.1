Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYLCQxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYLCQxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYLCQw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:52:59 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:42379 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYLCQw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:52:58 -0500
Message-ID: <4936B967.3070004@s5r6.in-berlin.de>
Date: Wed, 03 Dec 2008 17:52:55 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Andrej Hocevar <and.hocevar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: buffer i/o error
References: <20081203153302.GA12232@stoa>
In-Reply-To: <20081203153302.GA12232@stoa>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrej Hocevar wrote:
> Hello, I suddenly realized that one of my external disks (a Western Digital
> MyBook usb disk) wasn't accessible anymore. Then I found the following message.
> There seems to have been no apparent damage or loss, but I'm reporting it
> anyway.
> 
> Regards,
> 
> Andrej Hocevar
> 
> 
> ------------[ cut here ]------------
> WARNING: at fs/buffer.c:1186 mark_buffer_dirty+0x20/0x69()
[...]
>  [<c016fe20>] mark_buffer_dirty+0x20/0x69
>  [<c0198b88>] journal_update_superblock+0x4a/0x7c
>  [<c0198e00>] journal_destroy+0x101/0x146
>  [<c0126742>] autoremove_wake_function+0x0/0x2d
>  [<c018fcfd>] ext3_put_super+0x1f/0x147
>  [<c01578a6>] generic_shutdown_super+0x4a/0xad
>  [<c0157915>] kill_block_super+0xc/0x1b
[...]

This warning typically happens when the connection to a disk was lost.
Alas it doesn't tell /why/ the connection was lost.

http://kerneloops.org/guilty.php?guilty=journal_update_superblock has
more of this sort.
-- 
Stefan Richter
-=====-==--- ==-- ---==
http://arcgraph.de/sr/
