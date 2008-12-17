Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754875AbYLQM3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYLQM3X (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750916AbYLQM3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:05 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53723 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYLQM3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:02 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: GFS2: Pre-pull patch posting
Date: Wed, 17 Dec 2008 11:29:59 +0000
Message-Id: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for the next merge window, here is the current content
of the GFS2 git tree. Firstly, we have one new feature, which is
support for the FIEMAP ioctl. That patch does touch some code
outside of GFS2 itself, but its the only patch in this series which
does so.

The remaining patches are mostly clean up and bug fixes, as usual.
They are working towards a point where I can submit a patch to finally
merge the lock_dlm module (not dlm itself I should emphasise) into
GFS2. That is a large patch and a preliminary version has already been
posted to cluster-devel. My plan is to put that patch into my -nmw
git tree as the first patch for the following merge window to give
it maximum exposure.

The other highlight of this patch series, is a patch which removes
the two daemons (gfs2_scand and gfs2_glockd) and replaces them with
a "shrinker" routine registered with the VM. As expected, this also
reduces the code size. We are also expecting do do a similar thing
with the GFS2 quota data strucutures at some point in the future.

Steve.


