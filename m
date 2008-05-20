Return-Path: <linux-kernel-owner+w=401wt.eu-S934879AbYETWfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879AbYETWfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbYETWew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:34:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47624 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758899AbYETWev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:34:51 -0400
Date: Wed, 21 May 2008 00:35:43 +0200
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       macro@ds2.pg.gda.pl
Subject: Re: Unify common parts of i8259.c
Message-ID: <20080520223543.GA4705@elf.ucw.cz>
References: <20080520151528.GA1596@elf.ucw.cz> <20080520204750.GA31409@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520204750.GA31409@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> * Pavel Machek <pavel@suse.cz> wrote:
> 
> > Merge common parts of i8259_{32,64} into i8259.c.
> 
> hm, did you intend this to be a 'mechanic' (i.e. no functionality 
> changes expected) unification?

Yes, it should have been mechanic, but I guess I was not careful
enough.

> We'd prefer to have 10 or 20 small commits instead one large commit - 
> because in -tip we can bisect any problems to the exact change that 
> caused it - while now we are left to guess about a rather large
> change:

I don't think I can split it into 20 changes, but I should be able to
split it into 3 or so, and make them trivial enough to be bug
free. (In fact, there were only about 20 lines of "real" changes in
this, but it is impossible to see

>    6 files changed, 347 insertions(+), 609 deletions(-)

in this huge changelog). I'll produce better patches.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
