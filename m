Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZB1WRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZB1WRY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbZB1WRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:17:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37690 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbZB1WRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:17:15 -0500
Date: Sat, 28 Feb 2009 23:19:44 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090228221944.GG21230@elf.ucw.cz>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <20090227210856.GB1476@ucw.cz> <20090228165624.GC26292@one.firstfloor.org> <20090228220829.GE21230@elf.ucw.cz> <87wsba1a9f.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsba1a9f.fsf@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-02-28 23:12:28, Andi Kleen wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> 
> [trimmed cc list]
> 
> >> If you mean other attributes like large page vs small page: it's normally legal,
> >> with a few exceptions.
> >
> > ...but is it okay on other architectures, like sparc, with funky cache
> > setups?
> 
> I don't know for sure (how about you look it up in a sparc manual?), but
> I would assume it's also not safe there. I know it's not allowed in IA64 
> at least, with even some stricter rules than on x86.

So using aliases for kernel text rewriting is bad idea because it
would break ia64? That was what the thread was about. (Sorry, no ia64
or sparc manuals nearby).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
