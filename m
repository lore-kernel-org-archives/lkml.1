Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbZIPGhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbZIPGhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbZIPGhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:37:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51775 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZIPGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:37:38 -0400
Subject: [RFC/PATCH] SLQB: Mark the allocator as broken PowerPC and S390
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, cl@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, npiggin@suse.de,
       sachinp@in.ibm.com
Date: Wed, 16 Sep 2009 09:37:39 +0300
Message-Id: <1253083059.5478.1.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SLQB allocator is known to be broken on certain PowerPC and S390
configurations. Disable the allocator in Kconfig for those architectures
until the issues are resolved.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 init/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index c0d8a47..aaeddeb 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1033,6 +1033,7 @@ config SLUB
 
 config SLQB
 	bool "SLQB (Queued allocator)"
+	depends on !PPC && !S390
 	help
 	  SLQB is a proposed new slab allocator.
 
-- 
1.5.6.3



