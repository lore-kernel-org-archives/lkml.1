Return-Path: <linux-kernel-owner+w=401wt.eu-S1757557AbYEFMA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757557AbYEFMA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYEFMAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:00:18 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:36294 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYEFMAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:00:17 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: bad pmd ffff810000207808(9090909090909090).
Date: Tue, 06 May 2008 21:00:12 +0900
Message-ID: <874p9biqwj.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found today the following error in syslog. It seems have a strange
pattern. And it also happened at a month ago.

Any idea for debuging this?

Thanks.


May  6 07:21:36 duaron kernel: kjournald starting.  Commit interval 5 seconds
May  6 07:21:36 duaron kernel: EXT3 FS on sda2, internal journal
May  6 07:21:36 duaron kernel: EXT3-fs: mounted filesystem with ordered data mode.
May  6 07:21:36 duaron kernel: NET: Registered protocol family 15
May  6 07:21:36 duaron kernel: /devel/linux/works/linux-2.6/mm/memory.c:127: bad pmd ffff810000207808(9090909090909090).
May  6 07:21:36 duaron kernel: r8169: eth0: link up
May  6 07:21:36 duaron kernel: r8169: eth0: link up
May  6 07:21:36 duaron kernel: scsi 4:0:0:0: Direct-Access     USB2.0   CF  Card Reader   9144 PQ: 0 ANSI: 0
May  6 07:21:36 duaron kernel: sd 4:0:0:0: [sdc] Attached SCSI removable disk
May  6 07:21:36 duaron kernel: sd 4:0:0:0: Attached scsi generic sg3 type 0
May  6 07:21:36 duaron kernel: scsi 4:0:0:1: Direct-Access     USB2.0   CBO Card Reader   9144 PQ: 0 ANSI: 0
May  6 07:21:36 duaron kernel: sd 4:0:0:1: [sdd] Attached SCSI removable disk


Apr  9 03:53:40 duaron kernel: scsi 4:0:0:1: Direct-Access     USB2.0   CBO Card Reader   9144 PQ: 0 ANSI: 0
Apr  9 03:53:40 duaron kernel: sd 4:0:0:1: [sdd] Attached SCSI removable disk
Apr  9 03:53:40 duaron kernel: sd 4:0:0:1: Attached scsi generic sg4 type 0
Apr  9 03:53:40 duaron kernel: usb-storage: device scan complete
Apr  9 03:53:40 duaron kernel: NET: Registered protocol family 15
Apr  9 03:53:40 duaron kernel: /devel/linux/works/linux-2.6/mm/memory.c:127: bad pmd ffff810000207208(9090909090909090).
Apr  9 03:53:40 duaron kernel: r8169: eth0: link up
Apr  9 03:53:40 duaron kernel: r8169: eth0: link up
Apr  9 03:53:40 duaron kernel: RPC: Registered udp transport module.
Apr  9 03:53:40 duaron kernel: RPC: Registered tcp transport module.
Apr  9 03:53:40 duaron kernel: NET: Registered protocol family 10
Apr  9 03:53:40 duaron kernel: lo: Disabled Privacy Extensions
Apr  9 03:53:42 duaron kernel: p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
