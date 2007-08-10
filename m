Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbXHJFXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbXHJFXO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 01:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751624AbXHJFW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 01:22:59 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44405 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751445AbXHJFW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 01:22:58 -0400
Date: Thu, 9 Aug 2007 22:22:57 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLUB fixes
Message-ID: <Pine.LNX.4.64.0708092129190.19379@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/christoph/slab.git to-linus

Christoph Lameter (2):
      SLUB: Remove checks for MAX_PARTIAL from kmem_cache_shrink
      SLUB: Fix dynamic dma kmalloc cache creation

Jesper Juhl (1):
      SLUB: Fix format specifier in Documentation/vm/slabinfo.c

 Documentation/vm/slabinfo.c |    2 +-
 mm/slub.c                   |   68 +++++++++++++++++++++++++++++-------------
 2 files changed, 48 insertions(+), 22 deletions(-)
