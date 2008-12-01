Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYLAAnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYLAAnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 19:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbYLAAmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 19:42:36 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57961 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687AbYLAAme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 19:42:34 -0500
Date: Mon, 1 Dec 2008 00:42:32 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] further drm i915 fix.
Message-ID: <alpine.DEB.2.00.0812010041540.25353@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

One line which hopefully fixes further VT switch issue introduced fixing
last VT switch issue.

Dave.

 drivers/gpu/drm/i915/i915_gem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

commit 151903d5466fbcfb56ce792c3d5ea0ecbae15d07
Author: Eric Anholt <eric@anholt.net>
Date:   Mon Dec 1 10:23:21 2008 +1000

    drm/i915: Fix copy'n'pasteo that broke VT switch if flushing was non-empty.
    
    Introduced in the "Avoid BUG_ONs on VT switch" commit.
    
    Signed-off-by: Eric Anholt <eric@anholt.net>
    Signed-off-by: Dave Airlie <airlied@redhat.com>
