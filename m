Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbZCBCP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbZCBCP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:15:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZCBCPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:15:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52852 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756255AbZCBCPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:15:10 -0500
Message-ID: <49AB4162.9040504@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 10:16:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 4/4] cpuset: show correct file mode
References: <49AB40BF.4030706@cn.fujitsu.com>
In-Reply-To: <49AB40BF.4030706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset.memory_pressure is read-only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a46d693..1ed507c 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1671,6 +1671,7 @@ static struct cftype files[] = {
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
 		.private = FILE_MEMORY_MIGRATE,
+		.mode = 0444,
 	},
 
 	{
-- 1.5.4.rc3 
