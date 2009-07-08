Return-Path: <linux-kernel-owner+w=401wt.eu-S1760068AbZGHQH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068AbZGHQH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759243AbZGHQF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:05:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:53265 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759260AbZGHQF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:05:57 -0400
Subject: [PATCH 36/44] includecheck fix: include/drm, drm_memory.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:19:29 +0530
Message-Id: <1247068169.4382.99.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix the following 'make includecheck' warning:

  include/drm/drm_memory.h: linux/vmalloc.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/drm/drm_memory.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/include/drm/drm_memory.h b/include/drm/drm_memory.h
index 63e425b..15af9b3 100644
--- a/include/drm/drm_memory.h
+++ b/include/drm/drm_memory.h
@@ -44,8 +44,6 @@
 
 #if __OS_HAS_AGP
 
-#include <linux/vmalloc.h>
-
 #ifdef HAVE_PAGE_AGP
 #include <asm/agp.h>
 #else
-- 
1.6.0.6



