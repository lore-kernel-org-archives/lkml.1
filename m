Return-Path: <linux-kernel-owner+w=401wt.eu-S933068AbXGQBOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbXGQBOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbXGQBOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:14:17 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:42694 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbXGQBOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:14:16 -0400
Date: Tue, 17 Jul 2007 02:14:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@osdl.org, Andrew Morton <akpm@osdl.org>
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: [git pull] more drm patches for 2.6.23-rc1
Message-ID: <Pine.LNX.4.64.0707170212310.2500@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-932051438-1184634854=:2500"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-932051438-1184634854=:2500
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: 8BIT


Hi Linus,

Please pull the 'drm-patches' branch from:
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-patches

I was waiting on some idr patches to get into mainline via akpm, now that 
they've landed I can remove NIH bitfield allocators from the drm drawable 
and context code and just make it use idrs.

Dave.

  drivers/char/drm/drmP.h         |   11 +-
  drivers/char/drm/drm_context.c  |  131 +++++----------------
  drivers/char/drm/drm_drawable.c |  248 +++++++++------------------------------
  drivers/char/drm/drm_drv.c      |   15 +--
  4 files changed, 93 insertions(+), 312 deletions(-)

commit d4e2cbe9cb9219fc924191a6baa2369140cb5ea8
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Jul 17 10:55:47 2007 +1000

     drm: convert drawable code to using idr

     This converts the code for allocating drawables to the Linux idr,

     Fixes from: Michel Dänzer <michel@tungstengraphics.com>, Kristian Høgsberg <krh@redhat.com>

     Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 62968144e673016180f530fdfe170874b80ab5a7
Author: Dave Airlie <airlied@linux.ie>
Date:   Tue Jul 17 10:46:52 2007 +1000

     drm: convert drm context code to use Linux idr

     This converts the drm context allocator to an idr, using the new idr
     interface features from Kristian.

     Fixes from Kristian Hoegsberg <krh@redhat.com>

     Signed-off-by: Dave Airlie <airlied@linux.ie>
--29444707-932051438-1184634854=:2500--
