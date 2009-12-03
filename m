Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZLCTzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZLCTzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZLCTzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:55:47 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:39638 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbZLCTzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:55:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iyedZHkgXef+smKpKxAADUzZOeBU9QgV3W8QcAzXWdiqae9n5f82O+CdhVOsuueeAG
         renxp3L2sfn0dw0JMakhuPTm4bVmW0xGo1yYZytB066oT/caZKCNK2/YkQgkdEpr43jK
         B7XGrEt03Z7L24Brhz/GLXSPU3FzuS4JsvYdI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: Re: [PATCH 0/6] ide: dead/stale code removal
Date: Thu, 3 Dec 2009 20:54:49 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
References: <20091203195145.9093.88261.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200912032054.49131.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ uh, this time using the correct file, sorry for the noise ]

Hi,

Just a small cleanup removing dead/stale code from few IDE host drivers
(it makes comparisions between old/new drivers and porting fixes in both
directions much easier).


The following changes since commit 22763c5cf3690a681551162c15d34d935308c8d7:
  Linus Torvalds (1):
        Linux 2.6.32

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git ide-dcr

Bartlomiej Zolnierkiewicz (6):
      alim15x3: remove obsolete and dangerous wdc_udma parameter
      cmd64x: remove no longer needed debugging code
      cy82c693: remove no longer needed debugging code
      pdc202xx_old: remove no longer needed debugging code
      sis5513: remove stale TODO
      sl82c105: remove no longer needed debugging code

 drivers/ide/alim15x3.c     |   12 +-----------
 drivers/ide/cmd64x.c       |   17 -----------------
 drivers/ide/cy82c693.c     |   27 ---------------------------
 drivers/ide/pdc202xx_old.c |   15 ---------------
 drivers/ide/sis5513.c      |    9 ---------
 drivers/ide/sl82c105.c     |   24 +-----------------------
 6 files changed, 2 insertions(+), 102 deletions(-)
