Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZLaRGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZLaRGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 12:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbZLaRGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 12:06:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60097 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbZLaRGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 12:06:11 -0500
Date: Thu, 31 Dec 2009 17:06:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Dolding <oiaohm@gmail.com>
Cc: Samir Bellabes <sam@synack.fr>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Andrew G. Morgan" <morgan@kernel.org>,
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
       =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC][PATCH v3] Unprivileged: Disable raising of privileges
Message-ID: <20091231170641.6dd46c6e@lxorguk.ukuu.org.uk>
In-Reply-To: <e7d8f83e0912310608j2c52acabxbd57d24e2b3073ca@mail.gmail.com>
References: <m1iqbpwjtp.fsf@fess.ebiederm.org>
	<551280e50912300652r1007dee0j8de750bf33af9b3c@mail.gmail.com>
	<20091230183513.GC14493@us.ibm.com>
	<m1fx6suswz.fsf@fess.ebiederm.org>
	<20091230201712.GA23999@us.ibm.com>
	<m1hbr8tb8q.fsf_-_@fess.ebiederm.org>
	<20091230212931.233003b9@lxorguk.ukuu.org.uk>
	<m1skasrvnq.fsf@fess.ebiederm.org>
	<20091230230042.5d2e78ac@lxorguk.ukuu.org.uk>
	<m2bphfti1u.fsf@ssh.synack.fr>
	<e7d8f83e0912310608j2c52acabxbd57d24e2b3073ca@mail.gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Lets step back for a moment.  What is the common issue with both.
> 
> The issue is simple.  "How to I generically tell the secuirty system
> want particular restrictions."

You don't. It's not "the security system", its a whole collection of
completely different models of security and differing tools.

> There is no generic LSM API for application or users to talk to the
> LSM and say I want the following restricted.

That's a meaningless observation I think because security doesn't work
that way. Removing specific features from a specific piece of code
generally isn't a security feature - its only meaningful in the context
of a more general policy and that policy expression isn't generic.

> To control the LSM the applications are expected to know what the LSM.
>  This has caused items like chrome major issues.

..

> Application does not need to be informed what is disabled from it.

So why does it cause chrome problems ?


There are multiple security models because nobody can agree on what they
should look like, just like multiple desktops. Each of them is based on a
totally different conceptual model so the idea of a single interface to
them is a bit meaningless.

Alan
