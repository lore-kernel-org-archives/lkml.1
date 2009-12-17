Return-Path: <linux-kernel-owner+w=401wt.eu-S1765426AbZLQVn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765426AbZLQVn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 16:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765412AbZLQVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 16:43:23 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57732 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765407AbZLQVnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 16:43:22 -0500
Date: Thu, 17 Dec 2009 21:43:20 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2
Message-ID: <20091217214320.GG18217@ZenIV.linux.org.uk>
References: <20091217162454.GA18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912170831030.15740@localhost.localdomain> <20091217180319.GB18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912171008220.15740@localhost.localdomain> <20091217183952.GC18217@ZenIV.linux.org.uk> <alpine.LFD.2.00.0912171316220.15740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912171316220.15740@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 01:22:12PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 17 Dec 2009, Al Viro wrote:
> > 
> > reflog had been pruned already; still no effect.  Moreover, after looking
> > through the loose objects, I've found several commits that are definitely
> > reachable from master and now from your tree as well.  E.g.
> > objects/ea/ff8079d4f1016a12e34ab323737314f24127dd
> > is one of those - it's a commit and it's both in mainline *and* happens
> > to be tip of master.  No questions about being unreachable and AFAICS
> > no reasons whatsoever to leave it as a loose object...
> 
> If you want a maximal pack, use "git repack -Adl"

Still leaves the same bunch.

> The default gc thing will stop when it hits stuff that has been packed 
> already, which can leave _older_ unpacked objects unpacked. And since my 
> own repo isn't always fully packed, and git will only remove local objects 
> if they are available as _packed_ objects in the reference tree (ie my 
> repo), you'll end up with that kind of situation.

Yeah, but why aren't they put into local pack?  They _are_ new and they
definitely are referenced.  The newest in the repository, as the matter
of fact.

Odd...
