Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYLIS0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYLIS0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbYLIS02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:26:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:62673 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbYLIS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:26:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DQmW2PtkvunNiptTXq1uJIKSmQmvCkOkbKoHBkQbQG6PiJx+ZwtvUlb97/p0koEhCG
         Cp6PXpettui9sE2Nq1mRixYaBxdeZdZrJZ1m+iz+rTZmITN+B39laiFpmyzx6wSIc8Bw
         A4LDtE1WH6BQVD0r9aK2RVTnUECRxf4LooVN4=
Message-ID: <493EB851.5050104@gmail.com>
Date: Tue, 09 Dec 2008 19:26:25 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: airlied@linux.ie
CC: dri-devel@lists.sourceforge.net, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/33] drm/i915: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/gpu/drm/i915/i915_opregion.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index 13ae731..53dd21c 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -257,8 +257,8 @@ void opregion_enable_asle(struct drm_device *dev)
 
 static struct intel_opregion *system_opregion;
 
-int intel_opregion_video_event(struct notifier_block *nb, unsigned long val,
-			       void *data)
+static int intel_opregion_video_event(struct notifier_block *nb,
+		unsigned long val, void *data)
 {
 	/* The only video events relevant to opregion are 0x80. These indicate
 	   either a docking event, lid switch or display switch request. In

