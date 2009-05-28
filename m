Return-Path: <linux-kernel-owner+w=401wt.eu-S1763573AbZE1SQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763573AbZE1SQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZE1SQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:16:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:21138 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZE1SQb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,266,1241420400"; 
   d="scan'208";a="461239234"
From: "Eaton, Thomas G" <thomas.g.eaton@intel.com>
To: "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "airlied@linux.ie" <airlied@linux.ie>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 28 May 2009 12:16:23 -0600
Subject: [PATCH] drm: add connector and encoder types for MIPI displays
Thread-Topic: [PATCH] drm: add connector and encoder types for MIPI displays
Thread-Index: AQHJ37124IY8CFmgGk6jI2xBuEkgf5Aru46g
Message-ID: <4060059527C3A74384B5C4ED9D30CB99884CF09D@rrsmsx506.amr.corp.intel.com>
References: <4060059527C3A74384B5C4ED9D30CB998833847C@rrsmsx506.amr.corp.intel.com>
In-Reply-To: <4060059527C3A74384B5C4ED9D30CB998833847C@rrsmsx506.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added connector and encoder types for MIPI displays.

Signed-off-by: Thomas G Eaton <thomas.g.eaton@intel.com>

---
diff -uprN -X drm-2.6.orig/Documentation/dontdiff drm-2.6.orig/drivers/gpu/drm/drm_crtc.c drm-2.6/drivers/gpu/drm/drm_crtc.c
--- drm-2.6.orig/drivers/gpu/drm/drm_crtc.c     2009-05-28 10:17:02.000000000 -0700
+++ drm-2.6/drivers/gpu/drm/drm_crtc.c  2009-05-28 10:24:49.000000000 -0700
@@ -146,6 +146,7 @@ static struct drm_conn_prop_enum_list dr
        { DRM_MODE_CONNECTOR_DisplayPort, "DisplayPort", 0 },
        { DRM_MODE_CONNECTOR_HDMIA, "HDMI Type A", 0 },
        { DRM_MODE_CONNECTOR_HDMIB, "HDMI Type B", 0 },
+       { DRM_MODE_CONNECTOR_MIPI, "MIPI", 0 },
 };

 static struct drm_prop_enum_list drm_encoder_enum_list[] =
@@ -154,6 +155,7 @@ static struct drm_prop_enum_list drm_enc
        { DRM_MODE_ENCODER_TMDS, "TMDS" },
        { DRM_MODE_ENCODER_LVDS, "LVDS" },
        { DRM_MODE_ENCODER_TVDAC, "TV" },
+       { DRM_MODE_ENCODER_MIPI, "MIPI" },
 };

 char *drm_get_encoder_name(struct drm_encoder *encoder)
diff -uprN -X drm-2.6.orig/Documentation/dontdiff drm-2.6.orig/include/drm/drm_mode.h drm-2.6/include/drm/drm_mode.h
--- drm-2.6.orig/include/drm/drm_mode.h 2009-05-28 10:17:12.000000000 -0700
+++ drm-2.6/include/drm/drm_mode.h      2009-05-28 10:23:13.000000000 -0700
@@ -121,6 +121,7 @@ struct drm_mode_crtc {
 #define DRM_MODE_ENCODER_TMDS  2
 #define DRM_MODE_ENCODER_LVDS  3
 #define DRM_MODE_ENCODER_TVDAC 4
+#define DRM_MODE_ENCODER_MIPI  5

 struct drm_mode_get_encoder {
        __u32 encoder_id;
@@ -155,6 +156,7 @@ struct drm_mode_get_encoder {
 #define DRM_MODE_CONNECTOR_DisplayPort 10
 #define DRM_MODE_CONNECTOR_HDMIA       11
 #define DRM_MODE_CONNECTOR_HDMIB       12
+#define DRM_MODE_CONNECTOR_MIPI                13

 struct drm_mode_get_connector {

