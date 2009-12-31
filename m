Return-Path: <linux-kernel-owner+w=401wt.eu-S1753003AbZLaSlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbZLaSlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZLaSlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:41:18 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38784 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZLaSlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:41:17 -0500
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bryan Donlan <bdonlan@gmail.com>,
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
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
References: <551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	<m1fx6suswz.fsf@fess.ebiederm.org> <20091230201712.GA23999@us.ibm.com>
	<m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	<20091230212931.233003b9@lxorguk.ukuu.org.uk>
	<m1skasrvnq.fsf@fess.ebiederm.org>
	<20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
	<3e8340490912301844p4fddaf57ke58ceeba9582e0fa@mail.gmail.com>
	<20091231173334.5e3d7557@lxorguk.ukuu.org.uk>
	<20091231175257.GA7210@us.ibm.com>
	<551280e50912311020x2bdc5b1o699a601f67b91662@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 31 Dec 2009 10:41:08 -0800
In-Reply-To: <551280e50912311020x2bdc5b1o699a601f67b91662@mail.gmail.com> (Andrew G. Morgan's message of "Thu\, 31 Dec 2009 10\:20\:18 -0800")
Message-ID: <m1oclfkmuz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Andrew G. Morgan" <morgan@kernel.org> writes:

> Since there is already independent support for disabling file
> capabilities (the privilege escalation part), I see these two
> mechanisms as separable.

I guess there is something that resembles support for disabling
privilege escalation.  The problem is that it requires privilege to
use it.

I have no problem with expressing this in a fine grained manner internally
to the kernel but the user space interface needs to be atomic so that
we can enable this all without privilege.

Further I may be off but I think the implementation would be more
challenging than what I have already posted.  That doesn't mean it
won't be more useful long term.

Eric
