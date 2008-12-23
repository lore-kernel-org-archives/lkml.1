Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYLWAz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYLWAz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 19:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYLWAzT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 19:55:19 -0500
Received: from gir.skynet.ie ([193.1.99.77]:49866 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYLWAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 19:55:18 -0500
Date: Tue, 23 Dec 2008 00:55:16 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fix for 2.6.28 final
Message-ID: <alpine.DEB.2.00.0812230054330.16959@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1244707617-1229993716=:16959"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1244707617-1229993716=:16959
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This fixes a reported regression in the radeon irq handler.

Dave.

 drivers/gpu/drm/radeon/radeon_irq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

commit 077ebed54fe66612f58b076628a72eca2be8df90
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Dec 22 17:11:02 2008 +1000

    drm/radeon: fix correctness of irq_enabled check for radeon.
    
    This check was introduced with the logic the wrong way around.
    
    Fixes regression: http://bugzilla.kernel.org/show_bug.cgi?id=12216
    
    Tested-by: François Valenduc <francois.valenduc@tvcablenet.be>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
--29444707-1244707617-1229993716=:16959--
