Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZAHMr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZAHMr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbZAHMrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:47:19 -0500
Received: from tundra.namei.org ([65.99.196.166]:3702 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752489AbZAHMrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:47:18 -0500
Date: Thu, 8 Jan 2009 23:46:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: torvalds@osdl.org, akpm@linux-foundation.org, jirislaby@gmail.com,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix commit_creds() on a process that has no mm
In-Reply-To: <20090108111831.27076.81306.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0901082344470.15751@tundra.namei.org>
References: <20090108111831.27076.81306.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2009, David Howells wrote:

> Fix commit_creds()'s handling of a process that has no mm (such as one that is
> calling or has called daemonize()).  commit_creds() should check to see if
> task->mm is not NULL before calling set_dumpable() on it.

This looks correct in its own right, and is available for Linus to pull 
per below, but I'd also like to know that Jiri's problem is verified to be 
fixed.


The following changes since commit 9e42d0cf5020aaf217433cad1a224745241d212a:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/sparc-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

David Howells (1):
      CRED: Fix commit_creds() on a process that has no mm

 kernel/cred.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)
