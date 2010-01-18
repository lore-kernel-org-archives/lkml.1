Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328Ab0ARQEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328Ab0ARQEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 11:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754301Ab0ARQEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 11:04:34 -0500
Received: from mail-pz0-f190.google.com ([209.85.222.190]:61195 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0ARQEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 11:04:30 -0500
X-Greylist: delayed 460 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Jan 2010 11:04:30 EST
MIME-Version: 1.0
In-Reply-To: <17852.1263819244@localhost>
References: <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org>
	 <20100110215409.GA3705@heat> <20100110215848.GA26609@elf.ucw.cz>
	 <5768.1263264853@localhost>
	 <20100112075927.GA24256@atrey.karlin.mff.cuni.cz>
	 <32558.1263306523@localhost>
	 <20100114092250.GA11500@atrey.karlin.mff.cuni.cz>
	 <17852.1263819244@localhost>
Date: Mon, 18 Jan 2010 07:56:47 -0800
X-Google-Sender-Auth: 38a602431b1c5ed4
Message-ID: <551280e51001180756q2a438d3cv99bbb4e87eb073f4@mail.gmail.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Valdis.Kletnieks@vt.edu
Cc: Pavel Machek <pavel@ucw.cz>, Michael Stone <michael@laptop.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Am?rico Wang" <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 4:54 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> (Interestingly enough, the capabilities bug came *later*:
>
> 8.12.1/8.12.1   2001/10/01
>        SECURITY: Check whether dropping group privileges actually succeeded
>                to avoid possible compromises of the mail system by
>                supplying bogus data.  Add configuration options for
>                different set*gid() calls to reset saved gid.  Problem
>                found by Michal Zalewski.
>
> and was mostly an issue because the same problem existed in pre-8.12 sendmails
> that were still setuid and hadn't upgraded yet...
>
>

I think the above was 'a' sendmail bug. 'The' capabilities bug came before that:

http://userweb.kernel.org/~morgan/sendmail-capabilities-war-story.html

Cheers

Andrew
