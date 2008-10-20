Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbYJTV4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbYJTV4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJTV4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:56:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:51305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbYJTV4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=WEBsibJkzf8YjTH139FatLv8Hs5HBehjGqkoRuYnLnzKRA42MNKLnyw8axe/E29Uz7
         9NNxI0TkEV46fZvUFndwiKuzd96ZoDHHUc+N9q0kH1YJU1UDrG356ystvTA9yHECvP2v
         7ZacU9rak8zleywh5H+RuAAixzq7jEs31QE1I=
Date: Tue, 21 Oct 2008 01:56:01 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: menage@google.com, linux-kernel@vger.kernel.org
Subject: [PATCH] kernel/cgroup.c: remove unused variable
Message-ID: <20081020215601.GA21471@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 kernel/cgroup.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 046c160..ed21eb5 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2104,7 +2104,6 @@ static void *cgroup_tasks_start(struct seq_file *s, loff_t *pos)
 	down_read(&cgrp->pids_mutex);
 	if (pid) {
 		int end = cgrp->pids_length;
-		int i;
 		while (index < end) {
 			int mid = (index + end) / 2;
 			if (cgrp->tasks_pids[mid] == pid) {
