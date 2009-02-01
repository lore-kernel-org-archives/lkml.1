Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZBAT0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZBAT0w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZBAT0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:26:41 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:3657 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZBAT0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:26:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=O0SIkXqIwJScmsXwQocGWuV0vCAfOkiBGKuM0Piwn0+JerAS1vXgJHJeN7f23TTw8b
         whe7aqbrFJstIxd3qMNd5PtMWrnDf/cpkqnqqUaFlHKel2Al39aoiGfO7QFGDXtVawdR
         AmV9tvFZ5NMKaL1Pt1vekKj8yjrOo5+Un8ITs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 20:27:32 +0100
Message-Id: <20090201192732.1592.76435.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/8] ide: remove ->end_request method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


by-product of some other WIP...

on top of "[PATCH 00/15] weekly IDE updates" patchset
[ http://marc.info/?l=linux-kernel&m=123351051303529&w=2 ]

diffstat:
 drivers/ide/ide-atapi.c    |   17 +++--
 drivers/ide/ide-cd.c       |    1 
 drivers/ide/ide-disk.c     |    1 
 drivers/ide/ide-floppy.c   |  130 ++++++++++++++++-----------------------------
 drivers/ide/ide-gd.c       |    6 --
 drivers/ide/ide-gd.h       |    2 
 drivers/ide/ide-io.c       |   21 ++++---
 drivers/ide/ide-tape.c     |  124 ++++++++++++++----------------------------
 drivers/ide/ide-taskfile.c |   16 +----
 include/linux/ide.h        |   16 +++--
 10 files changed, 127 insertions(+), 207 deletions(-)
