Return-Path: <linux-kernel-owner+w=401wt.eu-S1757669AbZC1PQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbZC1PQg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 11:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZC1PQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 11:16:27 -0400
Received: from smtp-out25.alice.it ([85.33.2.25]:2806 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZC1PQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 11:16:26 -0400
Message-ID: <49CE3F31.4040100@alice.it>
Date: Sat, 28 Mar 2009 16:16:01 +0100
From: Mario Vanoni <vanonim@alice.it>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090324 SeaMonkey/1.1.15
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.28.9: EXT2-fs error
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Mar 2009 15:16:17.0384 (UTC) FILETIME=[2440CE80:01C9AFB8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_not_ in LKML and feedback only

- Intel Core 2 Dual 6320 1866MHz, 4096kB L2 cache, 4GB RAM
- HD Hitachi 1TB, 32MB on-board memory, ext2
- minimal (only ext2 & minix) static kernel 2.6.28.9
- updated Slackware 12.2

- cdrecord interrupted with many Ctrl-C
- machine hangs long time, no response
- then many, many messages
EXT2-fs error (device sda1): ext2_get_inode: unable to read inode block 
- inode=46612508, block=186449923
- then one line
EXT2-fs error (device sda1): ext2_free_branches: Read failure, 
inode=46612508, block=186449923
- then no more reaction, Ultima Ratio: Power Switch

Tried the same on a second machine,  100% identical HW and SW
- cdrecord interrupted with many Ctrl-C
- machine hangs for ever, no response
- no error messages on this machine
- after 30 minutes, Ultima Ratio: Power Switch
- after the fsck, the machine didn't reboot, asked for a extra manual fsck
- now rebooted as usual

Kind regards
Mario Vanoni


