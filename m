Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0CHPDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:03:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab0CHPD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:03:26 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Remove the EXPERIMENTAL flag
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-cachefs@redhat.com,
       Christian Kujau <lists@nerdbynature.de>,
       David Howells <dhowells@redhat.com>
Date: Mon, 08 Mar 2010 15:03:09 +0000
Message-ID: <20100308150309.31935.9800.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Kujau <lists@nerdbynature.de>

Remove the EXPERIMENTAL flag from FS-Cache so that Ubuntu can make use of the
facility.

Signed-off-by: Christian Kujau <lists@nerdbynature.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/fscache/Kconfig b/fs/fscache/Kconfig
index 864dac2..cc94bb9 100644
--- a/fs/fscache/Kconfig
+++ b/fs/fscache/Kconfig
@@ -1,7 +1,6 @@
 
 config FSCACHE
 	tristate "General filesystem local caching manager"
-	depends on EXPERIMENTAL
 	select SLOW_WORK
 	help
 	  This option enables a generic filesystem caching manager that can be

