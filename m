Return-Path: <linux-kernel-owner+w=401wt.eu-S1753286Ab0AKLxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0AKLxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 06:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223Ab0AKLxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 06:53:34 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56101 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0AKLxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 06:53:33 -0500
Date: Mon, 11 Jan 2010 12:53:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Michael Stone <michael@laptop.org>, Kyle Moffett <kyle@moffetthome.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100111115332.GA1697@atrey.karlin.mff.cuni.cz>
References: <f73f7ab81001101418x3b3f8652j256f6311ad6244c5@mail.gmail.com> <20100110230839.GB3825@heat> <3e8340491001101541tc776ad9r887be13393bcb7fd@mail.gmail.com> <4B4A83E0.9000207@schaufler-ca.com> <3e8340491001101815p887b96dr22b9b3f3108a7541@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340491001101815p887b96dr22b9b3f3108a7541@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> * If network access is restored over suid, then we can leak data over
> ping or any number of other routes, so that's right out.

ACK.

> * If network access is denied over suid, there are concerns of denial
> of service in certain configurations.

So that should be right out, too.

> * If suid is denied entirely, we have no denial of service or
> information leak concerns via the suid mechanism (since the mechanism
> is completely unusable). And if we really do need to execute something
> at an elevated privilege, we can ask a helper daemon to do it on our
> behalf.

Yes please. This is the obvious solution.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
