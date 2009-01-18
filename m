Return-Path: <linux-kernel-owner+w=401wt.eu-S933875AbZARP26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875AbZARP26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 10:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933784AbZARP2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 10:28:39 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:41503 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933786AbZARP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 10:28:37 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 0/3] drivers/gpu/drm: fix (sparse) warnings
To: dri-devel@lists.sourceforge.net
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 18 Jan 2009 16:28:31 +0100
Message-ID: <20090118152725.4179.40835.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series fixes a couple of (sparse) warnings.

---

Hannes Eder (3):
      drivers/gpu/drm: comment out dead code
      drivers/gpu/drm: fix sparse warnings: unexport symbols
      drivers/gpu/drm: fix sparse warnings: make symbols static


 drivers/gpu/drm/drm_crtc.c        |   17 ++++++++++-------
 drivers/gpu/drm/drm_crtc_helper.c |    6 +++---
 drivers/gpu/drm/drm_edid.c        |    4 ++--
 drivers/gpu/drm/drm_modes.c       |   13 +++++++------
 4 files changed, 22 insertions(+), 18 deletions(-)
