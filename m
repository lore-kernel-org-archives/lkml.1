Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYLRXG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYLRXG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 18:06:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbYLRXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 18:06:30 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:26253 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbYLRXG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 18:06:28 -0500
Message-ID: <494ad5ce.06e2660a.73b0.ffffd586@mx.google.com>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Thu, 18 Dec 2008 23:27:36 +0100
Subject: [PATCH 0/6] drm/i915: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches fixes a couple of sparse warnings in drm/i915.

Hannes Eder (6):
  drm/i915: fix sparse warnings: declare one-bit bitfield as unsigned
  drm/i915: fix sparse warnings: make symbols static
  drm/i915: fix sparse warnings: move 'extern' decls to header file
  drm/i915: fix sparse warnings: returning void-valued expression
  drm/i915: comment out unused function 'i915_driver_firstopen'
  drm/i915: add prototype for 'intelfb_panic' to header file

 drivers/gpu/drm/i915/dvo.h           |    6 ++++++
 drivers/gpu/drm/i915/i915_dma.c      |    8 +++++---
 drivers/gpu/drm/i915/i915_drv.c      |    2 +-
 drivers/gpu/drm/i915/i915_drv.h      |    8 ++++----
 drivers/gpu/drm/i915/i915_opregion.c |    4 ++--
 drivers/gpu/drm/i915/intel_crt.c     |    2 +-
 drivers/gpu/drm/i915/intel_display.c |   10 +++++-----
 drivers/gpu/drm/i915/intel_drv.h     |    2 ++
 drivers/gpu/drm/i915/intel_dvo.c     |   10 ++--------
 drivers/gpu/drm/i915/intel_fb.c      |   10 +++++-----
 drivers/gpu/drm/i915/intel_sdvo.c    |    9 +++++----
 drivers/gpu/drm/i915/intel_tv.c      |    2 +-
 12 files changed, 39 insertions(+), 34 deletions(-)

