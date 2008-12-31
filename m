Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbYLaMx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbYLaMx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 07:53:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbYLaMxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 07:53:02 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:2293 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994AbYLaMw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 07:52:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 31 Dec 2008 12:52:40 +0000
Message-Id: <1230727964-9268-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20081231125114.GC6596@sirena.org.uk>
References: <20081231125114.GC6596@sirena.org.uk>
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 1/5] regulator: Remove extraneous kerneldoc annotations
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of the internal structures have no kerneldoc but the ** at the start
of the comment marking them for documentation.  Remove the annotation
until some is added.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 895f738..7ba9491 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -29,7 +29,7 @@ static DEFINE_MUTEX(regulator_list_mutex);
 static LIST_HEAD(regulator_list);
 static LIST_HEAD(regulator_map_list);
 
-/**
+/*
  * struct regulator_dev
  *
  * Voltage / Current regulator class device. One for each regulator.
@@ -56,7 +56,7 @@ struct regulator_dev {
 	void *reg_data;		/* regulator_dev data */
 };
 
-/**
+/*
  * struct regulator_map
  *
  * Used to provide symbolic supply names to devices.
-- 
1.5.6.3

