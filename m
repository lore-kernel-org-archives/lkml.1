Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZLWT6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZLWT6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZLWT6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:58:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54987 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbZLWT6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:58:38 -0500
Date: Wed, 23 Dec 2009 20:58:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Please pull hwpoison fixes
Message-ID: <20091223195836.GA4125@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Repost, please disregard if you have it already queued]

Hi Linus,

This fixes a obscure build problem in the hwpoison injector
when PROC_FS is disabled.

-Andi

Please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6.git hwpoison

Andi Kleen (1):
      HWPOISON: Add PROC_FS dependency to hwpoison injector v2

 mm/Kconfig          |    2 +-
 mm/memory-failure.c |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)
-- 
ak@linux.intel.com -- Speaking for myself only.
