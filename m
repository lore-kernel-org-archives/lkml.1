Return-Path: <linux-kernel-owner+w=401wt.eu-S1755380AbYBYAIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380AbYBYAIS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYBYAIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:08:04 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44503 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbYBYAIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:08:01 -0500
Date: Mon, 25 Feb 2008 02:07:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/memcontrol.c: make 2 functions static
Message-ID: <20080225000706.GA2088@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes thefollowing needlessly global functions static:
- mem_cgroup_force_empty()
- mem_cgroup_write_strategy()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

0d8013bdcc403636cc326410af419e2e94d2450d diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6bded84..f13c577 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -878,7 +878,7 @@ retry:
  * This enables deleting this mem_cgroup.
  */
 
-int mem_cgroup_force_empty(struct mem_cgroup *mem)
+static int mem_cgroup_force_empty(struct mem_cgroup *mem)
 {
 	int ret = -EBUSY;
 	int node, zid;
@@ -909,7 +909,7 @@ out:
 
 
 
-int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
+static int mem_cgroup_write_strategy(char *buf, unsigned long long *tmp)
 {
 	*tmp = memparse(buf, &buf);
 	if (*buf != '\0')

