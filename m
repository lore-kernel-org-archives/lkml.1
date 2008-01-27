Return-Path: <linux-kernel-owner+w=401wt.eu-S1757074AbYA0InY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbYA0InY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 03:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbYA0Imd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 03:42:33 -0500
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:23883 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755492AbYA0Im3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 03:42:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=MTMGR2f0Zfo3+12yD7VnAJbPk8R4PXb1VaYo5FnJYY6tZC//UkeHSLCgbV+astigcjKvdUjAGwW8VrhWY+NKFBn1ZCmfZdNzF5SV/9/VYHsYUgBv9dI7AD/NiT1HsgFSAYOl7QeMPBMs8W9z/gxhWKWtmaeKqeaM5QIjdOvgT+Q=  ;
X-YMail-OSG: FrsaXsUVM1k82uqCjcUevl0ykBJ2hM_gJ3rvzYoaGPKEaWZVemBfUehZacsr00VHkq8UEeeWTA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 0/32] ide-tape redux v1
Date: Sun, 27 Jan 2008 09:41:20 +0100
Message-Id: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bart,

after a lot of hammering ide-tape got pimped pretty considerably (ca. 600 lines
shorter and slicker :)). I'm sure there's more to be done like, e.g. replacing
the BKL in idetape_write_release() with finer-grained locking etc, probably also
some pipeline improvements, removal of OnStream support, etc. but that'll come
later.

 Documentation/ide/ChangeLog.ide-tape.1995-2002 |  405 +++
 drivers/ide/Kconfig                            |    3 +-
 drivers/ide/ide-tape.c                         | 4146 +++++++++---------------
 3 files changed, 1991 insertions(+), 2563 deletions(-)

-- 
Regards/Gruﬂ,
   Boris.
