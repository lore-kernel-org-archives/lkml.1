Return-Path: <linux-kernel-owner+w=401wt.eu-S1753959AbZA0WIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbZA0WIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 17:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbZA0WH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 17:07:56 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:48557 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752019AbZA0WHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 17:07:55 -0500
X-YMail-OSG: _Q3HsakVM1nBhg6Rvr0tuOOXGkmigsTkLEBP2ztbc4uowHqCZab5oeUaF3IqQ4Y4sOgbcppLmMwmzbFtu1wiKChs4M7IafA6fgGD.68YJF7LPInEZU7ecLRBeIgI3ldLv90UrfGcvWqLNP3BD7hFPW60..myQEgW6ByToDjo00EYsC3ndspEU_hE7Xf_kXjoqCLxModCXnoMdG990nwNfKxhhlsDysk-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 0/4] [Target_Core_Mod]: Updates for TYPE_ROM and
	VARIABLE_LENGTH_CMD
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 14:06:46 -0800
Message-Id: <1233094006.6442.101.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all,

This series updates adds the VLC_SA_RECEIVE_CREDENTIAL define per James's feedback,
and converts target_core_mod to use include/linux/cdrom.h:GPCMD_* prefixed MMC Opcode
defines for TYPE_ROM.

This patch is made against lio-core-2.6.git/master
and tested on v2.6.29-rc2 x86 32-bit HVM.  The lio-core-2.6.git tree can be
found at:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=summary

[PATCH 1/4] [Linux/SCSI]: Change RECEIVE_CREDENTIAL to VLC_SA_RECEIVE_CREDENTIAL
[PATCH 2/4] [Target_Core_Mod]: Change RECEIVE_CREDENTIAL -> VARIABLE_LENGTH_CMD
[PATCH 3/4] [Target_Core_Mod]: Remove LOAD_UNLOAD_MEDIUM usage from IBLOCK/FILEIO/RAMDISK
[PATCH 4/4] [Target_Core_Mod]: Convert TYPE_ROM support to use include/linux/cdrom.h GPCMD_* defines

>From /pub/scm/linux/kernel/git/nab/lio-core-2.6
 * branch            master     -> FETCH_HEAD
Updating e384da7..a4bcd2c
Fast forward
 drivers/lio-core/target_core_base.h      |   59 ------------------------------
 drivers/lio-core/target_core_file.c      |    1 -
 drivers/lio-core/target_core_iblock.c    |    1 -
 drivers/lio-core/target_core_rd.c        |    1 -
 drivers/lio-core/target_core_transport.c |   31 +++++++++-------
 include/scsi/scsi.h                      |    4 ++-
 6 files changed, 20 insertions(+), 77 deletions(-)

--nab

