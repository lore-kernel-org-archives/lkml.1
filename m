Return-Path: <linux-kernel-owner+w=401wt.eu-S1764016AbZFLOEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764016AbZFLOEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762282AbZFLOEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:04:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56535 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763816AbZFLOES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:04:18 -0400
Subject: GFS2: Pull request #2
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 12 Jun 2009 15:01:39 +0100
Message-Id: <1244815299.3216.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


Please consider pulling the following two patches,

Steve.

----------------------------------------------------------------------------
The following changes since commit 8ebf975608aaebd7feb33d77f07ba21a6380e086:
  Randy Dunlap (1):
        block: fix kernel-doc in recent block/ changes

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Steven Whitehouse (2):
      GFS2: Add tracepoints
      GFS2: Remove lock_kernel from gfs2_put_super()

 fs/gfs2/Makefile     |    1 +
 fs/gfs2/bmap.c       |    3 +
 fs/gfs2/glock.c      |   12 ++-
 fs/gfs2/log.c        |    9 +-
 fs/gfs2/lops.c       |    3 +
 fs/gfs2/ops_fstype.c |    2 +
 fs/gfs2/rgrp.c       |   11 +-
 fs/gfs2/super.c      |    4 -
 fs/gfs2/trace_gfs2.h |  407 ++++++++++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 442 insertions(+), 10 deletions(-)
 create mode 100644 fs/gfs2/trace_gfs2.h


