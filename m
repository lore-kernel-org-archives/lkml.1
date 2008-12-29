Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYL2Db4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYL2Db4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:31:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbYL2Dbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:31:47 -0500
Received: from tundra.namei.org ([65.99.196.166]:3094 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYL2Dbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:31:47 -0500
Date: Mon, 29 Dec 2008 14:30:48 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [GIT] Security changes for 2.6.29
In-Reply-To: <alpine.LFD.2.00.0812281651480.3082@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0812291429520.14432@tundra.namei.org>
References: <alpine.LFD.2.00.0812281232350.3057@localhost.localdomain> <alpine.LRH.1.10.0812251158550.27893@tundra.namei.org> <7921.1230511311@redhat.com> <alpine.LFD.2.00.0812281651480.3082@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008, Linus Torvalds wrote:

> On Mon, 29 Dec 2008, David Howells wrote:
> > 
> > Does this fix the warning?  My compiler doesn't show it; of course, I'm not
> > using gcc-4.3.2, but something older.
> 
> Yup, this seems to fix it for me in my quick test. It seems that not 
> initializing the pointer for the error case makes gcc unhappy.
> 

This fix is available to be pulled:

The following changes since commit 
3c92ec8ae91ecf59d88c798301833d7cf83f2179:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus

David Howells (1):
      KEYS: Fix variable uninitialisation warnings

 security/keys/keyctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


-- 
James Morris
<jmorris@namei.org>
