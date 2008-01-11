Return-Path: <linux-kernel-owner+w=401wt.eu-S1760193AbYAKHHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbYAKHHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 02:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYAKHHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 02:07:47 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52318 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759598AbYAKHHo (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 02:07:44 -0500
Date: Fri, 11 Jan 2008 18:07:36 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.24-rc8
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080111070737.115D758C4C0F@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from the for-linus branch:
    git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus

This will update the following files:

 fs/xfs/linux-2.6/xfs_file.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

through these commits:

commit aea6ad0ce5e215ce99fe9e3edd9268f696862d8f
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Jan 10 16:43:26 2008 +1100

    [XFS] fix unaligned access in readdir
    
    This patch should fix the issue seen on Alpha with unaligned accesses in
    the new readdir code. By aligning each dirent to sizeof(u64) we'll avoid
    unaligned accesses. To make doubly sure we're not hitting problems also
    rearrange struct hack_dirent to avoid holes.
    
    SGI-PV: 975411
    SGI-Modid: xfs-linux-melb:xfs-kern:30302a
    
    Signed-off-by: Christoph Hellwig <hch@infradead.org>
    Signed-off-by: Lachlan McIlroy <lachlan@sgi.com>
