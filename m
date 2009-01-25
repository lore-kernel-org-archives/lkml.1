Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZAYUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZAYUkL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 15:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZAYUj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 15:39:58 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:48384 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbZAYUj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 15:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=lt2l7B2OcVJ4JcwDeI05OrWLqmsluH6YbIUGWyUO+s9UrWWYalroa7A+Mtl/wfOPvh
         S0D9MHXSBeBumH7Z/bX922NeOr+64avRo5fqm47kIOAaWe85Lw55ZDNr1Wxmw9DAqMzj
         oxS7q+Qymktq66dHXuCqZBXkAFDyeb32I5Ds8=
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 02:09:56 +0530
Message-ID: <3f9a31f40901251239k3e368feeib33661d82497725b@mail.gmail.com>
Subject: hdb: status error: error=0x40 <3>{ UncorrectableError }
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I added extra IDE drive I get similar messages like below so I replace
it another drive but I am still getting similar error messages on
2.6.29-rc2-tip:

hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=0
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
Buffer I/O error on device hdb, logical block 0
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=8
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 8
Buffer I/O error on device hdb, logical block 1
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=16
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 16
Buffer I/O error on device hdb, logical block 2
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=24
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 24
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=0
ide: failed opcode was: unknown
end_request: I/O error, dev hdb, sector 0
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=4294967295
ide: failed opcode was: 0xea
hdb: drive not ready for command
hdb: wcache flush failed!
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=4294967295
ide: failed opcode was: 0xec
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=4294967295
ide: failed opcode was: 0xa1
hdb: drive not ready for command
hdb: status error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdb: status error: error=0x40 <3>{ UncorrectableError },
LBAsect=208845, sector=4294967295
ide: failed opcode was: 0xea
hdb: drive not ready for command
hdb: wcache flush failed!

How can I fix these error.

Thanks,

--
JSR
