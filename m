Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbZBFWEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbZBFWEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758163AbZBFWEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:04:00 -0500
Received: from tundra.namei.org ([65.99.196.166]:4683 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbZBFWD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:03:59 -0500
Date: Sat, 7 Feb 2009 09:02:59 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [GIT] security: fix regression caused by creds code
Message-ID: <alpine.LRH.1.10.0902070854040.21582@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the regression per 
http://bugzilla.kernel.org/show_bug.cgi?id=12602

Please apply.

The following changes since commit 6cec50838ed04a9833fb5549f698d3756bbe7e72:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

David Howells (1):
      CRED: Fix SUID exec regression

 fs/compat.c   |    2 +-
 fs/exec.c     |   28 ++++++++++++++++++++++------
 fs/internal.h |    2 +-
 3 files changed, 24 insertions(+), 8 deletions(-)

-- 
James Morris
<jmorris@namei.org>
