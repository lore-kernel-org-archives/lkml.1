Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbYC1VGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbYC1VGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbYC1VGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:06:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59941 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754738AbYC1VGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:06:08 -0400
Date: Fri, 28 Mar 2008 14:06:04 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] adt7473: Minor documentation update
Message-ID: <20080328210604.GA7183@tree.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sentence about when fan speed increases to maximum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/adt7473 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Documentation/hwmon/adt7473 b/Documentation/hwmon/adt7473
index 22d8b19..2126de3 100644
--- a/Documentation/hwmon/adt7473
+++ b/Documentation/hwmon/adt7473
@@ -69,7 +69,8 @@ point2: Set the pwm speed at a higher temperature bound.
 
 The ADT7473 will scale the pwm between the lower and higher pwm speed when
 the temperature is between the two temperature boundaries.  PWM values range
-from 0 (off) to 255 (full speed).
+from 0 (off) to 255 (full speed).  Fan speed will be set to maximum when the
+temperature sensor associated with the PWM control exceeds temp#_max.
 
 Notes
 -----
