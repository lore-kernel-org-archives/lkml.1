Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHNALD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHNALD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 20:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbYHNAKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 20:10:53 -0400
Received: from tundra.namei.org ([65.99.196.166]:56341 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbYHNAKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 20:10:52 -0400
Date: Thu, 14 Aug 2008 10:10:11 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       David Howells <dhowells@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: [GIT] Credentials API wrappers for 2.6.27
Message-ID: <alpine.LRH.1.10.0808141000210.27061@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below from David Howells adds wrappers for the new credentials 
wrappers without utilizing them (except for XFS per below), so that 
subsystems may be converted over to the new API in smaller pieces.

This approach was suggested by Stephen here:
http://marc.info/?l=linux-kernel&m=121843301206340&w=2

Some changes were made to the XFS code to eliminate namespace collisions, 
and these have been updated according to feedback from Christoph (who has 
also since ok'd them to me personally).

Please pull.

The following changes since commit 8d0968abd03ec6b407df117adc773562386702fa:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../herbert/crypto-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

David Howells (1):
      CRED: Introduce credential access wrappers

 fs/xfs/linux-2.6/xfs_linux.h |    2 -
 fs/xfs/xfs_inode.c           |    4 +-
 fs/xfs/xfs_vnodeops.c        |    8 +++---
 include/linux/cred.h         |   50 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h        |    1 +
 5 files changed, 57 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/cred.h


