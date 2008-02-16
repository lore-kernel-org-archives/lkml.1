Return-Path: <linux-kernel-owner+w=401wt.eu-S1759379AbYBPRnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759379AbYBPRnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 12:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbYBPRnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 12:43:17 -0500
Received: from main.gmane.org ([80.91.229.2]:58862 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759063AbYBPRnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 12:43:15 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>
Subject: vfat32 Free Cluster Count Update
Date: Sat, 16 Feb 2008 18:43:47 +0100
Message-ID: <fp77bc$akv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bras-co-85-197-3-127.westend.de
User-Agent: KNode/0.10.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Doesn't the Linux vfat driver update the FAT32's free cluster summary count?

Zweiblum:~# dosfsck /dev/sda11
dosfsck 2.11, 12 Mar 2005, FAT32, LFN
/dev/sda11: 2451 files, 28218/1918827 clusters

Zweiblum:~# mount /dev/sda11 /mnt/win_daten/

Zweiblum:~# cp /etc/motd /mnt/win_daten/

Zweiblum:~# umount /mnt/win_daten/

Zweiblum:~# dosfsck /dev/sda11
dosfsck 2.11, 12 Mar 2005, FAT32, LFN
Free cluster summary wrong (1890609 vs. really 1890608)
1) Correct
2) Don't correct
? ^C

Zweiblum:~# uname -a
Linux Zweiblum 2.6.24-1-686 #1 SMP Mon Feb 11 14:37:45 UTC 2008 i686
GNU/Linux

Greetings,

  Gunter

