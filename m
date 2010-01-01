Return-Path: <linux-kernel-owner+w=401wt.eu-S1751972Ab0AAOxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab0AAOxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702Ab0AAOxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:53:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48774 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0AAOxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:53:08 -0500
Date: Fri, 1 Jan 2010 15:53:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Bryan Donlan <bdonlan@gmail.com>,
       Benny Amorsen <benny+usenet@amorsen.dk>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Message-ID: <20100101145305.GC3944@atrey.karlin.mff.cuni.cz>
References: <m1hbr8tb8q.fsf_-_@fess.ebiederm.org> <20091230212931.233003b9@lxorguk.ukuu.org.uk> <m1skasrvnq.fsf@fess.ebiederm.org> <20091230230042.5d2e78ac@lxorguk.ukuu.org.uk> <3e8340490912301844p4fddaf57ke58ceeba9582e0fa@mail.gmail.com> <20091231173334.5e3d7557@lxorguk.ukuu.org.uk> <20091231175257.GA7210@us.ibm.com> <551280e50912311020x2bdc5b1o699a601f67b91662@mail.gmail.com> <m1aawzm1tc.fsf@fess.ebiederm.org> <20100101144300.023f47a5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100101144300.023f47a5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > - unprivileged process took action to prevent gaining a capability.
> > - exec'd suid sendmail.
> > - sendmail took action as root because it could not become someone else.
> 
> Which is a classic bug and replicated historically in cpu time, quota and
> other similar "remove rights and then .." attacks.

Yes, so from now on, when we add new "cpu cache misses quota", we
should require prctl(I_SHOULD_NOT_BE_ABLE_TO_LAUNCH_SETUID) for
unpriviledged users, first.


								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
