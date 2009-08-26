Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbZHZQR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbZHZQR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZHZQRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:17:24 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:60665 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667AbZHZQRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:17:24 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [PATCH 0/6] thermal: improvements re. forced passive cooling
Date: Wed, 26 Aug 2009 18:17:19 +0200
Message-Id: <1251303445-25317-1-git-send-email-elendil@planet.nl>
X-Mailer: git-send-email 1.5.6.5
X-OriginalArrivalTime: 26 Aug 2009 16:17:25.0637 (UTC) FILETIME=[B3140B50:01CA2668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set three new patches in addition to four sent earlier as:
- [PATCH 0/3] acpi: improvements for Documentation/thermal/sysfs-api.txt
- [PATCH] acpi: thermal: display forced passive trip points in proc

There's one new whitespace fix in patch 1/1 from the first set;
patch 3/3 from that set was dropped as it was NACKed by Rui.

The first two patches in this series are purely documentation; the
others enhance functionality.

I've added Matthew in CC as he orginally implemented forced cooling.
Sujith Thomas is only CCed on the first two patches.

 Documentation/thermal/sysfs-api.txt |  393 ++++++++++++++++++-----------------
 drivers/acpi/thermal.c              |    7 +
 drivers/thermal/thermal_sys.c       |   17 +-
 3 files changed, 222 insertions(+), 195 deletions(-)

Cheers,
FJP

