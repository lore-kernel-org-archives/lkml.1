Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873Ab0AAObG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0AAObG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 09:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751Ab0AAObF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 09:31:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58683 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0AAObE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 09:31:04 -0500
Date: Fri, 1 Jan 2010 15:31:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
Message-ID: <20100101143100.GA3944@atrey.karlin.mff.cuni.cz>
References: <20091227010441.GA12077@heat> <20091227010650.GA12190@heat> <20091230185053.GB18712@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091230185053.GB18712@us.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Michael Stone (michael@laptop.org):
> > Implement security_* hooks for socket_create, socket_bind, socket_connect,
> > socket_sendmsg, and ptrace_access_check which return -EPERM when called from a
> > process with networking restrictions. Exempt AF_UNIX sockets.
> > 
> > Signed-off-by: Michael Stone <michael@laptop.org>
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>

For the record: NAK, as it introduces security holes.
											Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
