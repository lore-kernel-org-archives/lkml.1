Return-Path: <linux-kernel-owner+w=401wt.eu-S1752547AbYHROFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbYHROFV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752736AbYHROEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:04:33 -0400
Received: from tundra.namei.org ([65.99.196.166]:56365 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbYHROEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:04:32 -0400
Date: Tue, 19 Aug 2008 00:03:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-next@vger.kernel.org, David Fries <david@fries.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <17141.1219064130@redhat.com>
Message-ID: <alpine.LRH.1.10.0808190000210.21404@tundra.namei.org>
References: <20080818100151.c2e9e508.sfr@canb.auug.org.au> <17141.1219064130@redhat.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Aug 2008, David Howells wrote:

> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > As expected (reported by David Fries), today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > In file included from include/linux/tracehook.h:52,
> >                  from arch/powerpc/kernel/signal.c:13:
> > include/linux/security.h: In function 'security_ptrace_traceme':
> > include/linux/security.h:1760: error: 'parent' undeclared (first use in this function)
> > 
> > Caused by commit 5cd9c58fbe9ec92b45b27e131719af4f2bd9eb40 ("security: Fix
> > setting of PF_SUPERPRIV by __capable()").  The version of this commit
> > that has been in the linux-next tree from Aug 8 to Aug 15 is correct, so
> > I have no idea what happened.
> 
> I accidentally posted an old patch which James, maybe, substituted for the
> good one that he had.

I took the patch you sent me, although after some IRC discussion, what 
should have happened is that I should have git-cherry-pick'd the patch 
from the next-creds branch (where it had been tested in linux-next for 
some time) into for-linus rather than asking for an updated patch.

Sorry folks.


- James
-- 
James Morris
<jmorris@namei.org>
