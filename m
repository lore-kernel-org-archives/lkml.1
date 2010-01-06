Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536Ab0AFBUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0AFBUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 20:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407Ab0AFBUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 20:20:46 -0500
Received: from mail.perches.com ([173.55.12.10]:1535 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab0AFBU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 20:20:27 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 7/8] fs/ocfs2/cluster/tcp.c: Remove use of NIPQUAD, use %pI4
Date: Tue,  5 Jan 2010 17:20:19 -0800
Message-Id: <ec11c9ed70064e4f1137da23e51171a3620943f6.1262726222.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1262726222.git.joe@perches.com>
References: <cover.1262726222.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/cluster/tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ocfs2/cluster/tcp.c b/fs/ocfs2/cluster/tcp.c
index 334f231..7a9620e 100644
--- a/fs/ocfs2/cluster/tcp.c
+++ b/fs/ocfs2/cluster/tcp.c
@@ -72,9 +72,9 @@
 
 #include "tcp_internal.h"
 
-#define SC_NODEF_FMT "node %s (num %u) at %u.%u.%u.%u:%u"
+#define SC_NODEF_FMT "node %s (num %u) at %pI4:%u"
 #define SC_NODEF_ARGS(sc) sc->sc_node->nd_name, sc->sc_node->nd_num,	\
-			  NIPQUAD(sc->sc_node->nd_ipv4_address),	\
+			  &sc->sc_node->nd_ipv4_address,		\
 			  ntohs(sc->sc_node->nd_ipv4_port)
 
 /*
-- 
1.6.6.rc0.57.gad7a

