Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYGOGDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYGOGDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 02:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYGOGDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 02:03:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40103 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756884AbYGOGDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 02:03:37 -0400
Date: Tue, 15 Jul 2008 07:03:35 +0100 (IST)
From: Dave Airlie <airlied@skynet.ie>
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fix for 2.6.27-rc1
Message-ID: <alpine.DEB.0.82.0807150702330.6038@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

It appears we have a PAT incomPATibility, with how the radeon driver was 
mapping some VRAM.

Dave.

 drivers/gpu/drm/drm_memory.c       |    5 +++++
 drivers/gpu/drm/radeon/radeon_cp.c |    2 +-
 include/drm/drmP.h                 |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

commit 242e3df80b8d25ed681c278512df0993725f25dd
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Jul 15 15:48:05 2008 +1000

    drm/radeon: fixup issue with radeon and PAT support.
    
    With new userspace libpciaccess we can get a conflicting mapping
    on the PCIE GART table in the video RAM. Always try and map it _wc.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
