Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZBRBbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZBRBbc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 20:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757246AbZBRBbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 20:31:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757243AbZBRBbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 20:31:01 -0500
Message-ID: <499B64DA.5070403@cn.fujitsu.com>
Date: Wed, 18 Feb 2009 09:31:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] cgroups: update documentation about css_set hash table
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The css_set hash table was introduced in 2.6.26, so update the documentation
accordingly.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index d9e5d6f..93feb84 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -252,10 +252,8 @@ cgroup file system directories.
 When a task is moved from one cgroup to another, it gets a new
 css_set pointer - if there's an already existing css_set with the
 desired collection of cgroups then that group is reused, else a new
-css_set is allocated. Note that the current implementation uses a
-linear search to locate an appropriate existing css_set, so isn't
-very efficient. A future version will use a hash table for better
-performance.
+css_set is allocated. The appropriate existing css_set is located by
+looking into a hash table.
 
 To allow access from a cgroup to the css_sets (and hence tasks)
 that comprise it, a set of cg_cgroup_link objects form a lattice;
-- 
1.5.4.rc3
