Return-Path: <linux-kernel-owner+w=401wt.eu-S1755609AbZEPBOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbZEPBOp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 21:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZEPBOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 21:14:36 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57984 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbZEPBOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 21:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=wtgrS8H9M/QOatyS4E3oQZxFigf4cibNyvs39URvrWON26t4QdBR0Faz2ybhFhGWUV
         5L7fLvYO97rfJL96bohBwZzj16OqUKBJF73eF2nWTj/Z2CM0ZUTMB7Vvi2UTx9RuFxqa
         g8Lal/DLMkhJVooJS5RaauQY6l7h7E/AmuCII=
MIME-Version: 1.0
Date: Fri, 15 May 2009 21:14:35 -0400
X-Google-Sender-Auth: 0eb560a57954800b
Message-ID: <30353c3d0905151814p7e0afb23y1b0f0e0acb35a41f@mail.gmail.com>
Subject: 2.6.30-rc5 reiserfs bug
From: David Ellingsworth <david@identd.dyndns.org>
To: reiserfs-devel@veger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just built a kernel based off of the latest wireless-testing branch
and encountered this warning upon boot.

Regards,

David Ellingsworth

-------------------------------------------------------------------------------------

WARNING: at fs/namei.c:1251 warn_slowpath_null+0x10/0x15()
Hardware name: Presario 2100 (PF181UA)
Modules linked in: reiserfs ide_cd_mod ide_gd_mod cdrom
ide_pci_generic ohci_hcd alim15x3 ide_core natsemi usbcore thermal fan
Pid: 731, comm: exe Not tainted 2.6.30-rc5-wl #4
Call Trace:
 [<c0116690>] warn_slowpath_fmt+0x72/0xa1
 [<c0119da2>] ? __do_softirq+0xba/0xc2
 [<c0119e94>] ? irq_exit+0x28/0x2a
 [<c0103d00>] ? do_IRQ+0x5b/0x70
 [<c0102e29>] ? common_interrupt+0x29/0x30
 [<c0116f87>] ? vprintk+0x1fe/0x208
 [<dcd0b037>] ? prepare_error_buf+0x3e4/0x41e [reiserfs]
 [<c01166cf>] warn_slowpath_null+0x10/0x15
 [<c015cace>] lookup_one_len+0x30/0x9a
 [<dcd18596>] reiserfs_xattr_init+0x61/0x1af [reiserfs]
 [<dcd0a0f7>] reiserfs_fill_super+0xa8a/0xb98 [reiserfs]
 [<c0165fd1>] ? mntput_no_expire+0x19/0x97
 [<c01ad31c>] ? string+0x34/0x82
 [<c01addb3>] ? vsnprintf+0x65f/0x6a2
 [<c01ade5c>] ? snprintf+0x15/0x17
 [<c01851b1>] ? disk_name+0x5a/0x67
 [<c0157923>] get_sb_bdev+0xf2/0x138
 [<dcd08351>] get_super_block+0x13/0x15 [reiserfs]
 [<dcd0966d>] ? reiserfs_fill_super+0x0/0xb98 [reiserfs]
 [<c0156c42>] vfs_kern_mount+0x3c/0x77
 [<c0156cc1>] do_kern_mount+0x32/0xb9
 [<c0167410>] do_mount+0x5b5/0x5f3
 [<c0275e15>] ? iret_exc+0x4f9/0x9ab
 [<c01674af>] sys_mount+0x61/0x9a
 [<c0102875>] syscall_call+0x7/0xb
