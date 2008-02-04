Return-Path: <linux-kernel-owner+w=401wt.eu-S1757968AbYBDUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbYBDUIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYBDUIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:08:36 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49499 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756529AbYBDUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:08:35 -0500
Date: Mon, 4 Feb 2008 12:08:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: [git pull] SLUB updates for 2.6.25
Message-ID: <Pine.LNX.4.64.0802041206190.3241@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates for slub are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/vm.git slub-linus

Christoph Lameter (5):
      SLUB: Fix sysfs refcounting
      Move count_partial before kmem_cache_shrink
      SLUB: rename defrag to remote_node_defrag_ratio
      Add parameter to add_partial to avoid having two functions
      Explain kmem_cache_cpu fields

Harvey Harrison (1):
      slub: fix shadowed variable sparse warnings

Pekka Enberg (1):
      SLUB: Fix coding style violations

root (1):
      SLUB: Do not upset lockdep

 include/linux/slub_def.h |   15 ++--
 mm/slub.c                |  182 +++++++++++++++++++++++++---------------------
 2 files changed, 108 insertions(+), 89 deletions(-)
