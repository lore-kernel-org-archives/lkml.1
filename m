Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbYA1QMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbYA1QMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 11:12:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYA1QLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 11:11:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60208 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbYA1QLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 11:11:53 -0500
Date: Mon, 28 Jan 2008 17:11:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24 regression: Wake On Lan in sky2 broken on Mac mini
Message-ID: <20080128161134.GA25834@elte.hu>
References: <20080128002934.GA6354@dose.home.local> <18333.37002.749771.524523@harpo.it.uu.se> <20080128125535.GE32496@elte.hu> <18333.55970.74841.660462@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18333.55970.74841.660462@harpo.it.uu.se>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mikael Pettersson <mikpe@it.uu.se> wrote:

> Ok, I can see how my overly terse statement could be interpreted in 
> this way, and I apologize for that.
> 
> However, it _is_ a fact that there is a proliferation of specialized 
> mailing lists, and it is also a fact that many developers _only_ read 
> those lists. I'm in no way defending this behaviour, on the contrary I 
> probably dislike it as much as you do. But we can't ignore it.

i'm not worried about that aspect: those developers either write perfect 
code that never needs any tester or user assistance (in which case our 
discussion is moot), or if it's buggy then these developers will 
eventually be replaced with more capable people who are helping their 
testers and users more actively by reading lkml and responding there.

What we must not do is to give in to the splintering and laziness and 
actively _chase people away_ from lkml.

> I should of course have written something like "please cc: 
> <whateverlist>" instead of the stupid "wrong mailing" list comment.

yeah, thanks, that will do fine.

_Helping_ subsystem maintainers become aware of problems and 
cross-Cc:-ing to whatever preferred email alias they use (be that their 
own mailing list address or netdev@) is a necessary and positive feature 
of lkml: almost by definition the user has little idea about what is 
wrong with their kernel, and if the mail is unspecific enough or labeled 
incorrectly then it's easy for a maintainer to miss it. (It's already a 
very good first step when user know that the problem area is their 
kernel to begin with.)

Putting the "weight of initial discovery" on to the user on the other 
hand is actively harmful. It will only result in users picking the wrong 
list and being ignored there, upstream maintainers not getting a full 
picture about what kind of per subsystem bugs people are experiencing, 
etc., etc. The only thing that works in the long run is to make the 
private development email aliases _opt-in_ feature, and to always have a 
main body of information: lkml.

	Ingo
