Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZGHQC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZGHQC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbZGHQCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:02:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:52974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbZGHQCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:02:14 -0400
Subject: [PATCH 17/44] includecheck fix: um, helper.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: jdike@addtoit.com, user-mode-linux-devel@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 20:25:50 +0530
Message-Id: <1247064950.4382.45.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  arch/um/os-Linux/helper.c: linux/limits.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/um/os-Linux/helper.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/um/os-Linux/helper.c b/arch/um/os-Linux/helper.c
index 30860b8..b6b1096 100644
--- a/arch/um/os-Linux/helper.c
+++ b/arch/um/os-Linux/helper.c
@@ -15,7 +15,6 @@
 #include "os.h"
 #include "um_malloc.h"
 #include "user.h"
-#include <linux/limits.h>
 
 struct helper_data {
 	void (*pre_exec)(void*);
-- 
1.6.0.6



