Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957Ab0AaTiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0AaTiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 14:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871Ab0AaTiR
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 14:38:17 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:16174 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0AaTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 14:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references:mime-version:content-type:content-transfer-encoding;
        b=eSTVPu7VeCbjPp7qo3VchwoyJclK55ijhoXgvwPvR+7VbynETCcsV4RYdz9nbk7t0A
         +e6NqVa4Merj0GAxA9nrpSiUzwRXraKnPU3Jzs6EHDQ9gIavIRzyIS0IXJYdtIgxG5OT
         nwyiviBfFrpPhixJ2+Tz/pvHriCjLaXSso83M=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dan Nicholson <dbn.lists@gmail.com>, Dave Airlie <airlied@linux.ie>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jerome Glisse <jglisse@redhat.com>,
       Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
       dri-devel <dri-devel@lists.sf.net>,
       Alex Deucher <alexdeucher@gmail.com>,
       Kevin Winchester <kjwinchester@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 1/2] =?utf-8?q?radeon=5Fagp:=20Fix=20warning,=20format=20=E2=80=98%d=E2=80=99=20expects=20type=20=E2=80=98int=E2=80=99,=20but=20argument=204=20has=20type=20=E2=80=98size=5Ft=E2=80=99?=
Date: Sun, 31 Jan 2010 20:38:02 +0100
Message-Id: <1264966683-17992-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264966683-17992-1-git-send-email-jkacur@redhat.com>
References: <1264966683-17992-1-git-send-email-jkacur@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Fix warning by using %zu instead of %d for size_t
- Fix spelling mistake, "to" should be "too".

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_agp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
index c9ad7f5..f58c5f4 100644
--- a/drivers/gpu/drm/radeon/radeon_agp.c
+++ b/drivers/gpu/drm/radeon/radeon_agp.c
@@ -134,7 +134,7 @@ int radeon_agp_init(struct radeon_device *rdev)
 	int ret;
 
 	if (rdev->ddev->agp->agp_info.aper_size < 32) {
-		dev_warn(rdev->dev, "AGP aperture to small (%dM) "
+		dev_warn(rdev->dev, "AGP aperture too small (%zuM) "
 			"need at least 32M, disabling AGP\n",
 			rdev->ddev->agp->agp_info.aper_size);
 		return -EINVAL;
-- 
1.6.0.6

