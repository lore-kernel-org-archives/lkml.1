Return-Path: <linux-kernel-owner+w=401wt.eu-S935435AbYBOAor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435AbYBOAor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761622AbYBOAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:34 -0500
Received: from relay1.sgi.com ([192.48.171.29]:34266 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934698AbYBOAmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:32 -0500
Date: Thu, 14 Feb 2008 16:42:29 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: torvalds@linux-foundation.org
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [git pull] slab allocator fixes / cleanups
Message-ID: <Pine.LNX.4.64.0802141544130.3913@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit e760e716d47b48caf98da348368fd41b4a9b9e7e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../jejb/scsi-rc-fixes-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git slab-linus

Adrian Bunk (1):
      make slub.c:slab_address() static

Christoph Lameter (3):
      slub: Determine gfpflags once and not every time a slab is allocated
      slub: Fallback to kmalloc_large for failing higher order allocs
      slub: Support 4k kmallocs again to compensate for page allocator slowness

Marcin Slusarz (1):
      slab: avoid double initialization & do initialization in 1 place

Pekka Enberg (1):
      slub: kmalloc page allocator pass-through cleanup

 include/linux/slub_def.h |   15 +++++--
 mm/slab.c                |    3 +-
 mm/slub.c                |   94 
+++++++++++++++++++++++++++++++---------------
 3 files changed, 75 insertions(+), 37 deletions(-)

