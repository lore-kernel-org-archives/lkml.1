Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbYGUDuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbYGUDuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 23:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759046AbYGUDuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 23:50:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47992 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757778AbYGUDuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 23:50:07 -0400
Date: Mon, 21 Jul 2008 04:50:05 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [git pull] drm link ordering fix.
Message-ID: <alpine.DEB.0.82.0807210449300.22311@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

This changes the gpu link order to after char so drm happens after AGP.

Dave.

 drivers/Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

commit e6b51632b3579d96ce5aa1b3efdeceedd2921a2c
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Jul 21 08:42:36 2008 +1000

    gpu: re-order GPU subdirectory vs char for AGP vs DRM startup.
    
    Signed-off-by: Dave Airlie <airlied@linux.ie>
