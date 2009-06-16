Return-Path: <linux-kernel-owner+w=401wt.eu-S1764589AbZFPF5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764589AbZFPF5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 01:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935575AbZFPFvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 01:51:12 -0400
Received: from kroah.org ([198.145.64.141]:48361 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758254AbZFPFvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 01:51:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 22/64] firmware: FIRMWARE_NAME_MAX removal
Date: Mon, 15 Jun 2009 22:46:11 -0700
Message-Id: <1245131213-24168-22-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090616051351.GA23627@kroah.com>
References: <20090616051351.GA23627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Ortiz <sameo@linux.intel.com>

As we're allocating the firmware name dynamically, we no longer need this
definition.
This patch must be applied only after the 5 previous patches from this pacth
set have been applied.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/firmware.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/firmware.h b/include/linux/firmware.h
index c8ecf5b..d315446 100644
--- a/include/linux/firmware.h
+++ b/include/linux/firmware.h
@@ -5,7 +5,6 @@
 #include <linux/types.h>
 #include <linux/compiler.h>
 
-#define FIRMWARE_NAME_MAX 30 
 #define FW_ACTION_NOHOTPLUG 0
 #define FW_ACTION_HOTPLUG 1
 
-- 
1.6.3.2

