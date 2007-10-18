Return-Path: <linux-kernel-owner+w=401wt.eu-S1763297AbXJRCEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763297AbXJRCEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 22:04:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758430AbXJRCDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 22:03:53 -0400
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:34842 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756454AbXJRCDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 22:03:52 -0400
X-YMail-OSG: rQ5W7UIVM1mcXevTxGPCkFLj1PyUq_TygLmNcS2M2.cRMOn7S9v5dWYue6Nnh2q.jFu0dVKCUA--
X-RocketYMMF: rancidfat
Date: Wed, 17 Oct 2007 19:03:51 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: LSM conversion to static interface
To: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <200710180134.l9I1YGBW011092@sapphire.spiritone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <900019.22422.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Thomas Fricaccia <thomas_fricacci@yahoo.com> wrote:

> ...
> 
> But then I noticed that, while the LSM would remain in existence, it was
> being closed to out-of-tree security frameworks.  Yikes!  Since then, I've
> been following the rush to put SMACK, TOMOYO and AppArmor "in-tree". 
> 
> Since I know that the people behind these security frameworks are serious and
> worthy folk of general good repute,

I make no claims to worthyness, strongly deny being serious,
and challenge you to demonstrate my good repute.

> I've reluctantly come to the tentative
> conclusion that the fix is in. 

Nope. I remain carefully neutral regarding the static/dynamic LSM
issue. I was involved with the LSM when SELinux was still known as
the Flask port and my development group proposed the first
implementation, featuring authoritative hooks. Believe me, this
is nothing compared to what we went through as a community then.

> There seem to be powers at work that want LSM
> closed, and they don't want much public discussion about it.

The thing that killed authoritative hooks and that could kill LSM
is the notion (which I refuse to take a side on) that out of tree
facilities can use it to avoid the stated intent of the GPL.

> I think this is bad technology.  I've done due diligence by reviewing the
> LKML discussion behind closing LSM (and there isn't much).

I think the primary parties have gotten to the point where they
just call out the arguments by number we've been over them so many
times.

> The technical
> arguments seem to be (1) some people use the LSM interface for "non-security"
> purposes, which is frowned upon,

It goes way beyond frowned upon. The first use proposed for LSM was
an audit implementation and that was throughly shredded. Additional
restrictions on accesses only.

> (2) it's difficult to properly secure a
> system with an open-ended interface like LSM, and 

Which is pure feldercarb.

> (3) my security framework
> should be all any fair-minded person would ever want, so we won't let you use
> something else.

That argument makes Linus mad.

> Exactly. 
> 
> Well, any system that permits loading code into "ring 0" can't be made
> completely secure, so argument 2 reduces to argument 3, which is
> transparently self-serving (and invalid).
> 
> I submit for discussion the idea that a free and open operating system should
> preserve as much freedom for the end user as possible.  To this end, the
> kernel should cleanly permit and support the deployment of ANY security
> framework the end user desires, whether "in-tree" or "out-of-tree".  I agree
> that any out-of-tree LSM module should be licensed under the GPL (if for no
> other reason than many current commercial support contracts require
> non-tainted kernels).
> 
> But restricting security frameworks to "in-tree" only is bad technology.
> 
> "Freedom" includes the power to do bad things to yourself by, for example,
> making poor choices in security frameworks.  This possible and permitted end
> result shouldn't be the concern of kernel developers.  Making configuration
> and installation of user-chosen frameworks as clean and safe as possible
> should be.
> 
> In my opinion.
> 
> Though not sure why, I expect to be scorched by this.  Try not to patronize
> or condescend.  Give me technical arguments backed by real data.  Show me why
> a home user or 10,000 node commercial enterprise shouldn't be able to choose
> what he wants for security without having to jump through your hoops.  Show
> me why you shouldn't make his use of technology up to him, and as safely and
> conveniently as you can contrive.

The in-tree vs out-of-tree discussion is independent of LSM.


Casey Schaufler
casey@schaufler-ca.com
