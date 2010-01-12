Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571Ab0ALH7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0ALH7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 02:59:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542Ab0ALH7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 02:59:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44561 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0ALH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 02:59:29 -0500
Date: Tue, 12 Jan 2010 08:59:27 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: Michael Stone <michael@laptop.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100112075927.GA24256@atrey.karlin.mff.cuni.cz>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110215409.GA3705@heat> <20100110215848.GA26609@elf.ucw.cz> <5768.1263264853@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5768.1263264853@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 10 Jan 2010 22:58:48 +0100, Pavel Machek said:
> 
> > Scenario 2:
> > 
> > Mallory calls disablenetwork, calls sendmail as the first user after
> > boot; sendmail can't deliver anything (its network is disabled), but
> > starts forking and taking requests for other users, DoSing the mail
> > delivery.
> 
> You need to be root to start sendmail as a daemon.

Well, maybe, but mailer system where first user starts is as a daemon
makes sense... same for authentication system, etc. And it was okay
before disablenetwork come.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
