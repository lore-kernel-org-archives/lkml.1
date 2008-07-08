Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYGHVVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYGHVVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYGHVVU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:21:20 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41185 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYGHVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:21:19 -0400
Subject: [PATCH] init/version.c: Silenced sparse warning by declaring the
	version string.
From: Daniel Guilak <guilak@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, daniel@danielguilak.com
Content-Type: text/plain
Date: Tue, 08 Jul 2008 14:21:09 -0700
Message-Id: <1215552069.10304.6.camel@dguilak-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Guilak <daniel@danielguilak.com>
---
 init/version.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/version.c b/init/version.c
index 9d17d70..041fd82 100644
--- a/init/version.c
+++ b/init/version.c
@@ -16,6 +16,7 @@
 #define version(a) Version_ ## a
 #define version_string(a) version(a)
 
+extern int version_string(LINUX_VERSION_CODE);
 int version_string(LINUX_VERSION_CODE);
 
 struct uts_namespace init_uts_ns = {
-- 
1.5.4.3


