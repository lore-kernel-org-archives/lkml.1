Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYA2JLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYA2JLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 04:11:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYA2JLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 04:11:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:47794 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYA2JLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 04:11:19 -0500
Date: Tue, 29 Jan 2008 01:11:14 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH 1/2] hwmon: Define sysfs interface for energy consumption
	register
Message-ID: <20080129091114.GI2549@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expand the hwmon sysfs API to export energy consumption numbers.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/sysfs-interface |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
index f4a8ebc..e256bed 100644
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
