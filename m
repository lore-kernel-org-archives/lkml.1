Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYHMTKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYHMTKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 15:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYHMTKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 15:10:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbYHMTKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 15:10:47 -0400
Date: Wed, 13 Aug 2008 14:02:20 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] dlm fixes for 2.6.27-rc3
Message-ID: <20080813190220.GC24628@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull two simple dlm fixes from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

Thanks,
Dave

 fs/dlm/config.c |  203 +++++++++++++++++++++++++++++--------------------------
 fs/dlm/user.c   |   10 ++-
 2 files changed, 114 insertions(+), 99 deletions(-)


commit 51409340d240dabe66adb49f645588c3a802d055
Author: David Teigland <teigland@redhat.com>
Date:   Thu Jul 31 09:31:53 2008 -0500

    dlm: rename structs
    
    Add a dlm_ prefix to the struct names in config.c.  This resolves a
    conflict with struct node in particular, when include/linux/node.h
    happens to be included.
    
    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: David Teigland <teigland@redhat.com>

commit cb980d9a3ec3d39e30e0a4c473df528c09e0dcf3
Author: David Teigland <teigland@redhat.com>
Date:   Tue Jul 29 15:21:19 2008 -0500

    dlm: add missing kfrees
    
    A couple of unlikely error conditions were missing a kfree on the error
    exit path.
    
    Reported-by: Juha Leppanen <juha_motorsportcom@luukku.com>
    Signed-off-by: David Teigland <teigland@redhat.com>
