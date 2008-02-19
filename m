Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYBSKmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYBSKmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:42:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbYBSKmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:42:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33058 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbYBSKmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:42:43 -0500
Date: Tue, 19 Feb 2008 19:42:49 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Paul Menage <menage@google.com>
Subject: cpuset trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20080219193503.94A0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is easy documentation fix.

current implementation of cpuset track N_HIGH_MEMORY instead N_MEMORY.
(N_MEMORY doesn't exist in current implementation)


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Jackson <pj@sgi.com>
CC: Christoph Lameter <clameter@sgi.com>
CC: Paul Menage <menage@google.com>

---
 Documentation/cpusets.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/Documentation/cpusets.txt
===================================================================
--- a/Documentation/cpusets.txt 2008-02-14 13:42:22.000000000 +0900
+++ b/Documentation/cpusets.txt 2008-02-19 19:37:14.000000000 +0900
@@ -209,7 +209,7 @@ and name space for cpusets, with a minim
 The cpus and mems files in the root (top_cpuset) cpuset are
 read-only.  The cpus file automatically tracks the value of
 cpu_online_map using a CPU hotplug notifier, and the mems file
-automatically tracks the value of node_states[N_MEMORY]--i.e.,
+automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,
 nodes with memory--using the cpuset_track_online_nodes() hook.



