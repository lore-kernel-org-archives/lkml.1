Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbXJIUio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbXJIUio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 16:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbXJIUig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 16:38:36 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55206 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbXJIUif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 16:38:35 -0400
Date: Tue, 9 Oct 2007 13:39:24 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH v3] hwmon: Add power meter spec to
	Documentation/hwmon/sysfs-interface
Message-ID: <20071009203923.GJ16752@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the hwmon sysfs interface documentation to include a specification
for power meters.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/sysfs-interface |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index db7bb4a..4e0fb20 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -324,6 +324,37 @@ curr[1-*]_input	Current input value
 		Unit: milliampere
 		RO
 
+*********
+* Power *
+*********
+
+power[1-*]_average		Average power use
+				Unit: microWatt
+				RO
+
+power[1-*]_average_highest	Historical average maximum power use
+				Unit: microWatt
+				RO
+
+power[1-*]_average_lowest	Historical average minimum power use
+				Unit: microWatt
+				RO
+
+power[1-*]_input		Instantaneous power use
+				Unit: microWatt
+				RO
+
+power[1-*]_input_highest	Historical maximum power use
+				Unit: microWatt
+				RO
+
+power[1-*]_input_lowest		Historical minimum power use
+				Unit: microWatt
+				RO
+
+power[1-*]_reset_history	Reset input_highest, input_lowest,
+				average_highest and average_lowest.
+				WO
 
 **********
 * Alarms *
