Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbYAKMDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbYAKMDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 07:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758102AbYAKMD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 07:03:28 -0500
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:38657 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757991AbYAKMD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 07:03:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer;
  b=Kyyet3SqiNcqIL5aqGeKDOAXFixZFEFtlgLjIGGL0McU7hC0kjETL4yTjVFCT/SDQ5mwC4sD1NzQT0d7bDzLvAKzPnmZ5EC4oOQMQnttGnvffURAH66Js70YTtPOBD7x7/ovq0szSUWfy0TU1JAH/81B3SFFc/kMgaFDYvy5mBg=  ;
X-YMail-OSG: tXBnnIwVM1kOWTwVs6m4yTTqrM0yu7NyMiV8CBpVj.sLwVbc9eP7.tNoCAKf0fXc0dNfToTXKA--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Bartlomiej@gollum.tnic, Zolnierkiewicz@gollum.tnic, <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH 00/21] ide-floppy redux v2
Date: Fri, 11 Jan 2008 12:57:58 +0100
Message-Id: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Bart,

   here's the second version of the ide-floppy refactoring trail. All the
patches are based on the version of your quilt tree from the 05.01. Also, you've
already applied patch 5 in this series but i'm submitting it still for the sake
of completeness.


 drivers/ide/ide-cd.c     |    2 -
 drivers/ide/ide-floppy.c | 1403 ++++++++++++++++++----------------------------
 include/linux/cdrom.h    |    1 +
 include/linux/ide.h      |    3 +
 4 files changed, 558 insertions(+), 851 deletions(-)

p.s. Next stop: ide-tape.c :)
