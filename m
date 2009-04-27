Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZD0Kzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZD0Kzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 06:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbZD0Kzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 06:55:37 -0400
Received: from tundra.namei.org ([65.99.196.166]:36907 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755131AbZD0Kzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 06:55:36 -0400
Date: Mon, 27 Apr 2009 20:52:30 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Hugh Dickins <hugh@veritas.com>, stable@kernel.org,
       David Howells <dhowells@redhat.com>
Subject: [GIT] ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex
In-Reply-To: <2414.1240822042@redhat.com>
Message-ID: <alpine.LRH.2.00.0904272051240.18933@tundra.namei.org>
References: <20090426234134.GA13391@redhat.com> <20090425172524.GA3432@redhat.com> <20090424163949.GA12035@redhat.com> <20090423212250.GA22537@redhat.com> <20090423232717.975ABFC3C7@magilla.sf.frob.com> <31842.1240656853@redhat.com> <394.1240686417@redhat.com>
 <2414.1240822042@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the patch ready to pull for 2.6.30.

The following changes since commit ce8a7424d23a36f043d0de8484f888971c831119:
  Tim Abbott (1):
        sparc: convert to use __HEAD and HEAD_TEXT macros.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

Oleg Nesterov (1):
      ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex

 kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


-- 
James Morris
<jmorris@namei.org>
