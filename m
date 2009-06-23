Return-Path: <linux-kernel-owner+w=401wt.eu-S1758431AbZFWVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431AbZFWVcq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbZFWVca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:32:30 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41020 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbZFWVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:32:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=cq/Gw8rnDP/nFNdxceO9kDX+gSOhslM07SdUMO6WV7KX1/GNTTd5CTBABaeQUTMVX2
         gy7JrXdh5yzt/itcEiIrD+Wz9WhpT0acIIiJo23Hue3KzMhorc7hueKEQU0EDZXTaDTs
         JpkOAnJayQz7CNDdRMX30pV80p2TIv2lK5wrU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [patch 0/6] ide: various bugfixes
Date: Tue, 23 Jun 2009 23:23:30 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090623-11043-g1684859-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906232323.30762.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Dave,

As discussed before, here is the rest of my private bugfix queue.

All patches contain an extra info about the testing they have
received to make your decisions w.r.t. handling of them easier.

diffstat:
 drivers/ide/ide-devsets.c  |    2 -
 drivers/ide/ide-eh.c       |    2 -
 drivers/ide/ide-floppy.c   |    2 -
 drivers/ide/ide-io.c       |   70 ++++++++++++++++-----------------------------
 drivers/ide/ide-ioctls.c   |    8 +----
 drivers/ide/ide-iops.c     |   17 ++--------
 drivers/ide/ide-probe.c    |   31 +++++++++++++------
 drivers/ide/ide-proc.c     |   10 +-----
 drivers/ide/ide-taskfile.c |    9 +++++
 include/linux/ide.h        |    7 ++--
 10 files changed, 69 insertions(+), 89 deletions(-)
