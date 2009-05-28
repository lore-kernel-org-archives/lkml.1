Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbZE1Mp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbZE1Mp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 08:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbZE1Mps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 08:45:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZE1Mps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 08:45:48 -0400
Subject: [PATCH 1/2] net/netfilter: make symbol static
To: netdev@vger.kernel.org
From: Hannes Eder <hannes@hanneseder.net>
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 28 May 2009 14:45:43 +0200
Message-ID: <20090528124521.21789.46751.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  net/netfilter/nf_log.c:219:17: warning: symbol 'nf_log_sysctl_path' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 net/netfilter/nf_log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index beb3731..7511aed 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -216,7 +216,7 @@ static const struct file_operations nflog_file_ops = {
 #endif /* PROC_FS */
 
 #ifdef CONFIG_SYSCTL
-struct ctl_path nf_log_sysctl_path[] = {
+static struct ctl_path nf_log_sysctl_path[] = {
 	{ .procname = "net", .ctl_name = CTL_NET, },
 	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
 	{ .procname = "nf_log", .ctl_name = CTL_UNNUMBERED, },

