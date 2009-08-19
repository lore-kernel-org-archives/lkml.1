Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZHSQYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZHSQYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbZHSQYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:24:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42849 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753142AbZHSQYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:24:41 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] iio: Fix type warnings
To: linux-kernel@vger.kernel.org
Date: Wed, 19 Aug 2009 17:20:13 +0100
Message-ID: <20090819162011.8342.89107.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/iio/accel/sca3000_ring.c |    2 +-
 drivers/staging/iio/ring_sw.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
index b01876d..d5ea237 100644
--- a/drivers/staging/iio/accel/sca3000_ring.c
+++ b/drivers/staging/iio/accel/sca3000_ring.c
@@ -210,7 +210,7 @@ static struct attribute_group sca3000_ring_attr = {
 	.attrs = iio_ring_attributes,
 };
 
-static struct attribute_group *sca3000_ring_attr_groups[] = {
+static const struct attribute_group *sca3000_ring_attr_groups[] = {
 	&sca3000_ring_attr,
 	NULL
 };
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index c04ca4c..359ff92 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -392,7 +392,7 @@ static struct attribute_group iio_ring_attribute_group = {
 	.attrs = iio_ring_attributes,
 };
 
-static struct attribute_group *iio_ring_attribute_groups[] = {
+static const struct attribute_group *iio_ring_attribute_groups[] = {
 	&iio_ring_attribute_group,
 	NULL
 };

