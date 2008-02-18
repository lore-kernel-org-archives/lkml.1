Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYBRG1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYBRG1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 01:27:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbYBRG1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 01:27:44 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751631AbYBRG1o (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 01:27:44 -0500
Date: Mon, 18 Feb 2008 17:27:35 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.25-rc3
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080218062736.3322E58C4C11@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/Kbuild             |    6 --
 fs/xfs/Makefile           |  118 ++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/Makefile-linux-2.6 |  117 --------------------------------------------
 3 files changed, 117 insertions(+), 124 deletions(-)
 delete mode 100644 fs/xfs/Kbuild

through these commits:

commit 269cdfaf769f5cd831284cc831790c7c5038040f
Author: Lachlan McIlroy <lachlan@redback.melbourne.sgi.com>
Date:   Wed Nov 28 18:28:09 2007 +1100

    [XFS] Added quota targets and removed dmapi directory
    
    Fixes build failures introduced by bad merge to mainline.

commit 794f744b225aaf35742aac9e7b9dda96a9943413
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Nov 27 16:59:56 2007 +1100

    [XFS] Fix up xfs out-of-tree builds. (a.k.a. external modules)
    
    Change -I include directives to find headers in the out-of-tree spot. This
    allows a directory containing only xfs files to be built as:
    
    SGI-PV: 971186
    SGI-Modid: xfs-linux-melb:xfs-kern:29878a
    
    Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>

commit 58b7983d15a422d9616bdc4e245d5c31dfaefbe2
Author: Andi Kleen <ak@suse.de>
Date:   Tue Nov 27 16:53:47 2007 +1100

    [XFS] Remove Makefile wrappers in XFS
    
    Makefile (and Kbuild) would include Makefile-linux-26 I doubt XFS will
    really still compile on 2.4; so drop that. This moves Makefile-linux-26
    into Makefile and drops Kbuild. Also having wrappers as both Kbuild and
    Makefile seemed redundant anyways.
    
    The patch is relatively large because it renames a file, but no functional
    changes.
    
    SGI-PV: 971050
    SGI-Modid: xfs-linux-melb:xfs-kern:29781a
    
    Signed-off-by: Andi Kleen <ak@suse.de>
    Signed-off-by: Donald Douwsma <donaldd@sgi.com>
    Signed-off-by: Tim Shimmin <tes@sgi.com>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
