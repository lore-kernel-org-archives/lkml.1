Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbZFLTsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbZFLTsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 15:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZFLTsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 15:48:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41521 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbZFLTs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 15:48:29 -0400
Date: Fri, 12 Jun 2009 14:39:18 -0500
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.31
Message-ID: <20090612193917.GA31741@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.31 from:

 git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

They have all been in linux-next for quite a while, and are all minor
changes/fixes.
Dave


 fs/dlm/dir.c          |    7 ++++---
 fs/dlm/lockspace.c    |   17 ++++++++---------
 fs/dlm/lowcomms.c     |   22 ++++++++++++++++++----
 fs/dlm/lowcomms.h     |    3 ++-
 fs/dlm/member.c       |   19 +++++++++++++------
 fs/dlm/requestqueue.c |    2 +-
 include/linux/dlm.h   |    4 ++--
 7 files changed, 48 insertions(+), 26 deletions(-)


Christine Caulfield (1):
      dlm: connect to nodes earlier

David Teigland (2):
      dlm: fix use count with multiple joins
      dlm: use more NOFS allocation

Geert Uytterhoeven (1):
      dlm: Make name input parameter of {,dlm_}new_lockspace() const

