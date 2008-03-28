Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbYC1Vh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbYC1Vh2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755141AbYC1VhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:37:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54638 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbYC1VhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:37:16 -0400
Date: Fri, 28 Mar 2008 14:36:46 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH 1/2] Define sysfs interfaces for ibmaem driver
Message-ID: <20080328213646.GC7191@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update sysfs interface documentation to include energy meters and power
meter averaging intervals.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/sysfs-interface |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index f4a8ebc..85e6654 100644
--- a/Documentation/hwmon/sysfs-interface
+++ b/Documentation/hwmon/sysfs-interface
@@ -328,6 +328,14 @@ curr[1-*]_input	Current input value
 		Unit: milliampere
 		RO
 
+**********
+* Energy *
+**********
+
+energy[1-*]_input		Instantaneous energy use
+				Unit: microJoule
+				RO
+
 *********
 * Power *
 *********
@@ -336,6 +344,10 @@ power[1-*]_average		Average power use
 				Unit: microWatt
 				RO
 
+power[1-*]_interval		Power use averaging interval
+				Unit: milliseconds
+				RW
+
 power[1-*]_average_highest	Historical average maximum power use
 				Unit: microWatt
 				RO
