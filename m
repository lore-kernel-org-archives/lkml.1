Return-Path: <linux-kernel-owner+w=401wt.eu-S1761688AbZE1MqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761688AbZE1MqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761763AbZE1Mp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:45:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34923 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760868AbZE1Mpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:45:54 -0400
Subject: [PATCH 2/2] net/netfilter: remove redundant variable
To: netdev@vger.kernel.org
From: Hannes Eder <hannes@hanneseder.net>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 May 2009 14:45:51 +0200
Message-ID: <20090528124548.21789.63516.stgit@jazzy.zrh.corp.google.com>
In-Reply-To: <20090528124521.21789.46751.stgit@jazzy.zrh.corp.google.com>
References: <20090528124521.21789.46751.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/netfilter/nf_log.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 7511aed..b584cc2 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -47,7 +47,6 @@ int nf_log_register(u_int8_t pf, struct nf_logger *logger)
 	mutex_lock(&nf_log_mutex);
 
 	if (pf == NFPROTO_UNSPEC) {
-		int i;
 		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
 			list_add_tail(&(logger->list[i]), &(nf_loggers_l[i]));
 	} else {

