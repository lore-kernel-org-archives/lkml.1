Return-Path: <linux-kernel-owner+w=401wt.eu-S932678AbZKDVlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678AbZKDVlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932633AbZKDVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:41:15 -0500
Received: from tundra.namei.org ([65.99.196.166]:57129 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757456AbZKDVlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:41:11 -0500
Date: Thu, 5 Nov 2009 08:40:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>,
       linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [GIT] sysfs: Don't leak secdata when a sysfs_dirent is freed.
In-Reply-To: <20091104140913.GA4355@us.ibm.com>
Message-ID: <alpine.LRH.2.00.0911050839160.6457@tundra.namei.org>
References: <m1zl7236ox.fsf@fess.ebiederm.org> <20091104140913.GA4355@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a memory leak introduced in 2.6.32-rc5, please pull.


The following changes since commit 91d3f9bacdb4950d2f79fe2ba296aa249f60d06c:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../anholt/drm-intel

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Eric W. Biederman (1):
      sysfs: Don't leak secdata when a sysfs_dirent is freed.

 fs/sysfs/dir.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)


-- 
James Morris
<jmorris@namei.org>
