Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZLBW1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZLBW1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:27:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZLBW13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:27:29 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62198 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536AbZLBW11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:27:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=bbTtbNdXma2sVr6Qf/g59fMhe2Uc7AvACsckNAGJhJHHn5/e0roIcUpab7lzkBmMMf
         65fPsbqPDemJxQvywgSvkYHyJo49Y4Myom1CBD0hNISD/QiSFr9muMXG2UpRmTkDbAgs
         NtIEskalIBs4eIlUWYExWakt37m7ZswUfVTtg=
MIME-Version: 1.0
Date: Wed, 2 Dec 2009 14:27:33 -0800
Message-ID: <dd18b0c30912021427x4d1d952tcdd98bb9d816b67c@mail.gmail.com>
Subject: BUG kmalloc-8192: Poison overwritten
From: Justin Mattock <justinmattock@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no idea what this is:
(first time I've seen this);


[   13.055592] =============================================================================
[   13.055865] BUG kmalloc-8192: Poison overwritten
[   13.056046] -----------------------------------------------------------------------------
[   13.056049]
[   13.056366] INFO: 0xffff88003290a100-0xffff88003290a143. First byte
0x50 instead of 0x6b
[   13.056366] INFO: Allocated in ath_rxbuf_alloc+0x25/0x94 [ath]
age=8898 cpu=0 pid=892
[   13.056366] INFO: Freed in skb_release_data+0xc1/0xc6 age=99 cpu=0 pid=0
[   13.056366] INFO: Slab 0xffffea0000b0f9c0 objects=3 used=0
fp=0xffff88003290c090 flags=0x4000000000004082
[   13.056366] INFO: Object 0xffff88003290a048 @offset=8264
fp=0xffff880032908000
[   13.056366]
[   13.056366] Bytes b4 0xffff88003290a038:  b9 9e fb ff 00 00 00 00
5a 5a 5a 5a 5a 5a 5a 5a ¹.ûÿ....ZZZZZZZZ
[   13.056366]   Object 0xffff88003290a048:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a058:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a068:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a078:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a088:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a098:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a0a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a0b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a0c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a0d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a0e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a0f8:  6b 6b 6b 6b 6b 6b 6b 6b
50 00 3a 01 00 19 e3 06 kkkkkkkkP.:...ã.
[   13.056366]   Object 0xffff88003290a108:  2c 16 00 1e 2a 00 67 f0
00 1e 2a 00 67 f0 50 4d ,...*.gð..*.gðPM
[   13.056366]   Object 0xffff88003290a118:  51 c1 16 b3 0a 00 00 00
64 00 31 04 00 03 4a 50 QÁ.³....d.1...JP
[   13.056366]   Object 0xffff88003290a128:  4d 01 08 82 84 8b 96 0c
18 30 48 03 01 03 2a 01 M........0H...*.
[   13.056366]   Object 0xffff88003290a138:  00 32 04 12 24 60 6c e1
8b 12 b3 b3 6b 6b 6b 6b .2..$`lá..³³kkkk
[   13.056366]   Object 0xffff88003290a148:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a158:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a168:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a178:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a188:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a198:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a1a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a1b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a1c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a1d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a1e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a1f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a208:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a218:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a228:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a238:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a248:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a258:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a268:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a278:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a288:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a298:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a2a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a2b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a2c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a2d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a2e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a2f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a308:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a318:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a328:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a338:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a348:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a358:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a368:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a378:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a388:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a398:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a3a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a3b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a3c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a3d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a3e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a3f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a408:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a418:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a428:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a438:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a448:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a458:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a468:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a478:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a488:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a498:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a4a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a4b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a4c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a4d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a4e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a4f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a508:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a518:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a528:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a538:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a548:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a558:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a568:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a578:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a588:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a598:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a5a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a5b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a5c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a5d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a5e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a5f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a608:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a618:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a628:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a638:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a648:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a658:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a668:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a678:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a688:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a698:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a6a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a6b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a6c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a6d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a6e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a6f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a708:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a718:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a728:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a738:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a748:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a758:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a768:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a778:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a788:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a798:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a7a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a7b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a7c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a7d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a7e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a7f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a808:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a818:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a828:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a838:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a848:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a858:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a868:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a878:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a888:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a898:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a8a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a8b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a8c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a8d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a8e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a8f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a908:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a918:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a928:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a938:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a948:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a958:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a968:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a978:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a988:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a998:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a9a8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a9b8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a9c8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a9d8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a9e8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290a9f8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aa98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aaa8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aab8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aac8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aad8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aae8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aaf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ab98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aba8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290abb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290abc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290abd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290abe8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290abf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ac98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aca8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290acb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290acc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290acd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ace8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290acf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ad98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ada8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290adb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290adc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290add8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ade8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290adf8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290ae98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aea8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aeb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aec8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aed8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aee8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aef8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af08:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af18:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af28:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af38:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af48:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af58:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af68:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af78:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af88:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290af98:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290afa8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290afb8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290afc8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290afd8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290afe8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290aff8:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290b008:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290b018:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290b028:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]   Object 0xffff88003290b038:  6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[   13.056366]  Redzone 0xffff88003290c048:  bb bb bb bb bb bb bb bb
                      »»»»»»»»
[   13.056366]  Padding 0xffff88003290c088:  5a 5a 5a 5a 5a 5a 5a 5a
                      ZZZZZZZZ
[   13.056366] Pid: 0, comm: swapper Not tainted 2.6.32-rc8-00259-g2127816 #2
[   13.056366] Call Trace:
[   13.056366]  <IRQ>  [<ffffffff810e2407>] print_trailer+0x13b/0x144
[   13.056366]  [<ffffffff810e293b>] check_bytes_and_report+0xb5/0xe6
[   13.056366]  [<ffffffff810e2a31>] check_object+0xc5/0x202
[   13.056366]  [<ffffffff8139ed5e>] ? bss_release+0x3e/0x42
[   13.056366]  [<ffffffff810e2bfa>] __free_slab+0x8c/0x125
[   13.056366]  [<ffffffff810e2cc8>] discard_slab+0x35/0x37
[   13.056366]  [<ffffffff810e323d>] __slab_free+0x108/0x2f9
[   13.056366]  [<ffffffff813202c3>] ? skb_release_data+0xc1/0xc6
[   13.056366]  [<ffffffff813202c3>] ? skb_release_data+0xc1/0xc6
[   13.056366]  [<ffffffff810e4872>] kfree+0xd2/0xde
[   13.056366]  [<ffffffff81059f4a>] ? try_to_wake_up+0x294/0x2a6
[   13.056366]  [<ffffffff813202c3>] skb_release_data+0xc1/0xc6
[   13.056366]  [<ffffffff8131fe3f>] __kfree_skb+0x19/0x7c
[   13.056366]  [<ffffffff8131feca>] consume_skb+0x28/0x2a
[   13.056366]  [<ffffffff813b4970>] ieee80211_scan_rx+0x146/0x168
[   13.056366]  [<ffffffff813beaf7>] ieee80211_invoke_rx_handlers+0x5f/0x13b7
[   13.056366]  [<ffffffff810e2abf>] ? check_object+0x153/0x202
[   13.056366]  [<ffffffffa0048fef>] ? uhci_alloc_td+0x1a/0x48 [uhci_hcd]
[   13.056366]  [<ffffffffa0049269>] ? uhci_submit_common+0x24c/0x2eb [uhci_hcd]
[   13.056366]  [<ffffffff813c010a>] __ieee80211_rx_handle_packet+0x2bb/0x2d4
[   13.056366]  [<ffffffff813c08f8>] ieee80211_rx+0x54a/0x5c2
[   13.056366]  [<ffffffffa0108124>] ath_rx_send_to_mac80211+0xbf/0xce [ath9k]
[   13.056366]  [<ffffffffa0108a85>] ath_rx_tasklet+0x8c2/0x91e [ath9k]
[   13.056366]  [<ffffffff81031f33>] ? nommu_map_page+0x0/0xa8
[   13.056366]  [<ffffffffa0106aa4>] ath9k_tasklet+0x53/0xdb [ath9k]
[   13.056366]  [<ffffffff81062250>] tasklet_action+0x6f/0xba
[   13.056366]  [<ffffffffa0107fb7>] ? ath_isr+0x13d/0x156 [ath9k]
[   13.056366]  [<ffffffff81063a48>] __do_softirq+0xda/0x196
[   13.056366]  [<ffffffff8102d91c>] call_softirq+0x1c/0x28
[   13.056366]  [<ffffffff8102ecd7>] do_softirq+0x33/0x6b
[   13.056366]  [<ffffffff81063826>] irq_exit+0x36/0x78
[   13.056366]  [<ffffffff8102e3c3>] do_IRQ+0xa0/0xb7
[   13.056366]  [<ffffffff8102d193>] ret_from_intr+0x0/0xa
[   13.056366]  <EOI>  [<ffffffffa001ab88>] ?
acpi_idle_enter_bm+0x2ab/0x2d6 [processor]
[   13.056366]  [<ffffffffa001ab7e>] ? acpi_idle_enter_bm+0x2a1/0x2d6
[processor]
[   13.056366]  [<ffffffff812f2231>] ? cpuidle_idle_call+0x8e/0xe9
[   13.056366]  [<ffffffff8102bcbd>] ? cpu_idle+0x52/0x8d
[   13.056366]  [<ffffffff813cee2d>] ? rest_init+0x61/0x63
[   13.056366]  [<ffffffff8165cc24>] ? start_kernel+0x345/0x350
[   13.056366]  [<ffffffff8165c29c>] ? x86_64_start_reservations+0xac/0xb0
[   13.056366]  [<ffffffff8165c384>] ? x86_64_start_kernel+0xe4/0xeb
[   13.056366] FIX kmalloc-8192: Restoring
0xffff88003290a100-0xffff88003290a143=0x6b
[   13.056366]


I have been looking at udev today
to deal with a suspend issue
(took /lib/udev/write_cd_rules&write_net_rules
out temporarily to resolve a boot/suspend issue)



-- 
Justin P. Mattock
