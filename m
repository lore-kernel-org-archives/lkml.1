Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYADVNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYADVNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbYADVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:12:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:38027 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbYADVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:12:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=WLwpIBXta/qby5a234u7edz8qZrc39dEpEzxbvvBTTXexho343VXd+gf3xLFQxN2D+wFBbV6uJjS2+UrDV/ZcIhPaKzjlNdi2ParDSnmShGutLjlhpLcID2q2EfZaBER3yurQhsPk1k1UnhG6UTGY8tl/O00mCcTRjGrJGPReVU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2008 22:24:24 +0100
Message-Id: <20080104212424.6978.93646.sendpatchset@localhost.localdomain>
Subject: [PATCH 0/15] ide: fixes/cleanups for IDE devices probing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a preparation for a more sophisticated changes.

diffstat:

 drivers/ide/ide-iops.c            |    2
 drivers/ide/ide-probe.c           |  199 ++++++++++++++++----------------------
 drivers/ide/ide.c                 |  109 ++++++++++----------
 drivers/ide/legacy/ide_platform.c |   34 +-----
 drivers/ide/pci/ns87415.c         |    4
 include/linux/ide.h               |   15 --
 6 files changed, 157 insertions(+), 206 deletions(-)

Bart
