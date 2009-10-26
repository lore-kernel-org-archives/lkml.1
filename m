Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZJZHjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZJZHjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbZJZHjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:39:05 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:53784 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754858AbZJZHjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:39:02 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Frans Pop <elendil@planet.nl>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 2/6] thermal: sysfs-api.txt - document passive attribute for thermal zones
Date: Mon, 26 Oct 2009 08:39:00 +0100
Message-Id: <1256542744-26569-3-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1256542744-26569-1-git-send-email-elendil@planet.nl>
References: <1256542744-26569-1-git-send-email-elendil@planet.nl>
X-OriginalArrivalTime: 26 Oct 2009 07:39:05.0799 (UTC) FILETIME=[65541D70:01CA560F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Frans Pop <elendil@planet.nl>
Acked-by: Zhang Rui <rui.zhang@intel.com>
Cc: Sujith Thomas <sujith.thomas@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
 Documentation/thermal/sysfs-api.txt |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 895337f..a87dc27 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -199,6 +199,15 @@ cdev[0-*]_trip_point
 	point.
 	RO, Optional
 
+passive
+	Attribute is only present for zones in which the passive cooling
+	policy is not supported by native thermal driver. Default is zero
+	and can be set to a temperature (in millidegrees) to enable a
+	passive trip point for the zone. Activation is done by polling with
+	an interval of 1 second.
+	Unit: millidegrees Celsius
+	RW, Optional
+
 *****************************
 * Cooling device attributes *
 *****************************
-- 
1.5.6.5

