Return-Path: <linux-kernel-owner+w=401wt.eu-S1752047Ab0AAPGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab0AAPGK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 10:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951Ab0AAPGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 10:06:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46237 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0AAPGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 10:06:05 -0500
Date: Fri, 1 Jan 2010 16:06:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20100101150604.GF3944@atrey.karlin.mff.cuni.cz>
References: <20091227190802.GH11737@elf.ucw.cz> <20091228060759.GB13266@heat> <20091228101006.GA19984@elf.ucw.cz> <8817.1262011044@localhost> <20091228205511.GD1637@ucw.cz> <3e8340490912281333l1459f769yf621a36ad1ed6482@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e8340490912281333l1459f769yf621a36ad1ed6482@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > it is really only required for binaries setuid to someone else, but
> > that would be too ugly. (Plus, as someone said, ping is great for
> > leaking data out.)
> 
> No, this is not sufficient; one needs only to find a setuid process
> that can be convinced to run a program with the original (pre-suid)

Ok.

> Or one can target a non-root setuid program that may have security
> holes - how about nethack?

Well, security holes are bad idea, who'd know?

> That said, I do feel this is a separate issue. The process should
> first drop its ability to suid; then it can freely apply additional
> restrictions without there being any risk of breaking setuid
> applications.

ACK.

> In short, how does this sound:
> * Add an API to allow processes to permanently revoke their own
> ability to gain privileges from setuid-exec
> * Add this disablenetwork facility, conditional on dropping
> setuid-exec abilities
> 
> This also paves the way for:
> * Allow processes that have dropped said suid ability to freely create
> new namespaces (and chroot)

Works for me.

> Which, combined with doing whatever audits are necessary to allow
> cross-network-namespace uses of unix domain sockets, actually
> eliminates the need for the disablenetwork API. :)

Cool ;-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
