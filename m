Return-Path: <linux-kernel-owner+w=401wt.eu-S1760393AbZEZXV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393AbZEZXV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbZEZXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:18:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53168 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbZEZXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:18:32 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/17] x86: MCE: Deprecate old 32bit machine check code
Date: Wed, 27 May 2009 01:18:10 +0200
Message-Id: <2bc54830cc9e63d090dc461db0bdf99fc3d3cd4a.1243377662.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
References: <1243379896-26869-1-git-send-email-andi@firstfloor.org>
 <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
 <86b35f6b0b17e1edc38fb5c3178967ffc4d1fa0a.1243377662.git.ak@linux.intel.com>
 <5a2337a03ce794fe7cf69e338ffacacb3770797c.1243377662.git.ak@linux.intel.com>
 <4010bb177562589d0fd54043bb7bc6ea4d7998fd.1243377662.git.ak@linux.intel.com>
 <c21d841c7b7d68f60e52c9c20c3d9573cfd8bf95.1243377662.git.ak@linux.intel.com>
 <e625a26c7a082ec6033b4a836c98d7f725fe80f9.1243377662.git.ak@linux.intel.com>
 <b7b15c0ea92409e6641de1e90da9c63664066eba.1243377662.git.ak@linux.intel.com>
 <e2d81decded3202e410a569f8c224986f2e83668.1243377662.git.ak@linux.intel.com>
 <c8c4b619d810eba16e62044a38284761ef69c8f2.1243377662.git.ak@linux.intel.com>
 <91219e907da103fc39dba8d32aaa9f872f0e6cc1.1243377662.git.ak@linux.intel.com>
In-Reply-To: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
References: <bce28247059ad80b138de8ae9f22f9d13c856589.1243377662.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Schedule for removal in 2.6.32

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/feature-removal-schedule.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index de491a3..f5ba352 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -437,3 +437,13 @@ Why:	Superseded by tdfxfb. I2C/DDC support used to live in a separate
 	driver but this caused driver conflicts.
 Who:	Jean Delvare <khali@linux-fr.org>
 	Krzysztof Helt <krzysztof.h1@wp.pl>
+
+----------------------------
+
+What:	CONFIG_X86_OLD_MCE
+When:	2.6.32
+Why:	Remove the old legacy 32bit machine check code. This has been
+	superseded by the newer machine check code from the 64bit port,
+	but the old version has been kept around for easier testing. Note this
+        doesn't impact the old P5 and WinChip machine check handlers.
+Who:	Andi Kleen <andi@firstfloor.org>
-- 
1.6.0.2

