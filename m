Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbYIZFww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbYIZFww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 01:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYIZFwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 01:52:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751656AbYIZFwo (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 01:52:44 -0400
Date: Fri, 26 Sep 2008 15:52:35 +1000
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.27
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080926055235.9973458C52AE@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6ef190cc92e33565accff6a320f0e7d90480bfe7:
  Roland Dreier (1):
        IPoIB: Fix crash when path record fails after path flush

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/linux-2.6 master

Lachlan McIlroy (2):
      [XFS] Fix extent list corruption in xfs_iext_irec_compact_full().
      [XFS] Remove xfs_iext_irec_compact_full()

 fs/xfs/xfs_inode.c |   94 ++--------------------------------------------------
 1 files changed, 3 insertions(+), 91 deletions(-)
