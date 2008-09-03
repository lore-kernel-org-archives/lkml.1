Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbYICASU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbYICASU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 20:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbYICASM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 20:18:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:56520 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYICASM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 20:18:12 -0400
Date: Wed, 3 Sep 2008 10:17:26 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [GIT] Fix SELinux memory leak regression for 2.6.27
Message-ID: <alpine.LRH.1.10.0809031015260.17746@tundra.namei.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is causing recent Fedora systems to die a slow and painful death.  
Please pull.


The following changes since commit afa153fd7b6afcd55dd6df6aea06bb53aa1d3608:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../bart/ide-2.6

are available in the git repository at:

  
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Eric Paris (1):
      SELinux: memory leak in security_context_to_sid_core

 security/selinux/ss/services.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)


-- 
James Morris
<jmorris@namei.org>
