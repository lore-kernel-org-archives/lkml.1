Return-Path: <linux-kernel-owner+w=401wt.eu-S1761191AbZDIJe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761191AbZDIJe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDIJeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:34:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZDIJeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:34:18 -0400
Message-ID: <49DDC0EC.6050305@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 17:33:32 +0800
From: Shen Feng <shen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: balagi@justmail.de
CC: randy.dunlap@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] doc: use correct debugfs mountpoint
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use the default mountpoint of debugfs in the pktcdvd ABI.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 Documentation/ABI/testing/debugfs-pktcdvd |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-pktcdvd b/Documentation/ABI/testing/debugfs-pktcdvd
index bf9c16b..cf11736 100644
--- a/Documentation/ABI/testing/debugfs-pktcdvd
+++ b/Documentation/ABI/testing/debugfs-pktcdvd
@@ -1,4 +1,4 @@
-What:           /debug/pktcdvd/pktcdvd[0-7]
+What:           /sys/kernel/debug/pktcdvd/pktcdvd[0-7]
 Date:           Oct. 2006
 KernelVersion:  2.6.20
 Contact:        Thomas Maier <balagi@justmail.de>
@@ -10,10 +10,10 @@ debugfs interface
 The pktcdvd module (packet writing driver) creates
 these files in debugfs:
 
-/debug/pktcdvd/pktcdvd[0-7]/
+/sys/kernel/debug/pktcdvd/pktcdvd[0-7]/
     info            (0444) Lots of driver statistics and infos.
 
 Example:
 -------
 
-cat /debug/pktcdvd/pktcdvd0/info
+cat /sys/kernel/debug/pktcdvd/pktcdvd0/info
-- 
1.6.0.6
