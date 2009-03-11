Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZCKCYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZCKCYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 22:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZCKCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 22:23:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57556 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbZCKCXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 22:23:51 -0400
Date: Wed, 11 Mar 2009 02:23:48 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm edid parser fix
Message-ID: <alpine.DEB.2.00.0903110222520.28485@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Just a single line fix for backwards syncs, X had this wrong for years, 
don't believe wikipedia.

Dave.

 include/drm/drm_edid.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 260cf8a2cbe022131a4850ea6175ed716dc2663c
Author: Pantelis Koukousoulas <pktoss@gmail.com>
Date:   Tue Mar 10 13:16:14 2009 +0200

    drm: fix EDID parser problem with positive/negative hsync/vsync
    
    Comparing the layouts of struct detail_pixel_timing with
    x.org's struct detailed_timings and how those are handled,
    it appears that the hsync_positive and vsync_positive
    fields are backwards.
    
    This patch fixes https://bugs.freedesktop.org/show_bug.cgi?id=20019
    for me. It was tested on 2 monitors, LG FLATRON L225WS 22" and
    a YAKUMO 17" for which more details are unknown.
    
    Signed-off-by: Pantelis Koukousoulas <pktoss@gmail.com>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
