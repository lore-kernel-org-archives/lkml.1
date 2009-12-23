Return-Path: <linux-kernel-owner+w=401wt.eu-S1756852AbZLWUjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbZLWUjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 15:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZLWUjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 15:39:10 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47465 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbZLWUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 15:39:09 -0500
Date: Wed, 23 Dec 2009 21:39:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: [GIT PULL] Please pull sysctl fixes
Message-ID: <20091223203901.GA31704@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

When I looked into sysctls last week I ended up with a patchkit fixing
various issues. This branch has the 2.6.33 worthy versions of the
patches, fixing more serious issues. The other stuff is for 2.6.34

- Only print compat sysctls once using an external hash table
as discussed. This gives better compatibility to all possible
old sysctl users.
- Fix nasty race in zone_list_fallback sysctl

Please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git sysctl

to get

Andi Kleen (2):
      SYSCTL: Print binary sysctl warnings (nearly) only once
      SYSCTL: Add a mutex to the page_alloc zone order sysctl

 kernel/sysctl_binary.c |   31 ++++++++++++++++++++++++++++++-
 mm/page_alloc.c        |   11 +++++++----
 2 files changed, 37 insertions(+), 5 deletions(-)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
