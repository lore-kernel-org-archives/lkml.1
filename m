Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbZKBHrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbZKBHrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZKBHrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:47:36 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:45390 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001AbZKBHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:47:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=k4EK2ZEREM3o+Grn79TYlWFuzQ5OH4bdpFDaJPGwtTrXe71jBeOE4l/YaSE3Iu0ufI
         B9kY02ofkVxiCzmgnEovy3ZTxDELCDF30802+GnqWw5CMrxh0mvxMj4r/n/EO6gHrG7t
         xEG4t3sCJ6PaBb300ecuKO2ZrX5/j4DbJLewY=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 15:47:40 +0800
Message-ID: <b741c2440911012347g33af3519l1b0562c5331c02c3@mail.gmail.com>
Subject: [PATCH 3/3] Fix a typo
From: Liu Aleaxander <aleaxander@gmail.com>
To: menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6d5d6c4fc84144009fa960b091e5742d3f135211 Mon Sep 17 00:00:00 2001
From: Liu Aleaxander <Aleaxander@gmail.com>
Date: Mon, 2 Nov 2009 14:38:09 +0800
Subject: [PATCH 3/3] Fix a typo

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 Documentation/cgroups/cgroups.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt
b/Documentation/cgroups/cgroups.txt
index 0b33bfe..73734db 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -523,7 +523,7 @@ int pre_destroy(struct cgroup_subsys *ss, struct
cgroup *cgrp);

 Called before checking the reference count on each subsystem. This may
 be useful for subsystems which have some extra references even if
-there are not tasks in the cgroup. If pre_destroy() returns error code,
+there are no tasks in the cgroup. If pre_destroy() returns error code,
 rmdir() will fail with it. From this behavior, pre_destroy() can be
 called multiple times against a cgroup.

-- 
1.6.2.5

-- 
regards
Liu Aleaxander
