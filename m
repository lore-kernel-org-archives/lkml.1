Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab0BGHfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 02:35:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:59527 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab0BGHfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 02:35:30 -0500
Date: Sun, 7 Feb 2010 18:34:51 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Xiaotian Feng <dfeng@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       serue@linux.vnet.ibm.com, Al Viro <viro@zeniv.linux.org.uk>,
       Eugene Teo <eugene@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [GIT][IMA] fix null pointer deref
In-Reply-To: <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
Message-ID: <alpine.LRH.2.00.1002071832080.21000@tundra.namei.org>
References: <1265364881-8140-1-git-send-email-dfeng@redhat.com> <OFD4EDD9E8.3C38BC7C-ON852576C1.004B1271-852576C1.004BCFCC@us.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull this bugfix.  I've verified that it fixes the null pointer 
deref.


The following changes since commit 29275254caedfedce960cfe6df24b90cb04fe431:
  Linus Torvalds (1):
        Linux 2.6.33-rc7

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

J. R. Okajima (1):
      ima: fix null pointer deref

 fs/pipe.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)
