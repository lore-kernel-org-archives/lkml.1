Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967Ab0AJVqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab0AJVqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 16:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437Ab0AJVqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 16:46:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:34645 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab0AJVqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 16:46:43 -0500
Date: Mon, 11 Jan 2010 08:44:44 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Pavel Machek <pavel@ucw.cz>
cc: "Serge E. Hallyn" <serue@us.ibm.com>, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Am?rico Wang <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 2/3] Security: Implement disablenetwork semantics. (v4)
In-Reply-To: <20100110211609.GC26079@elf.ucw.cz>
Message-ID: <alpine.LRH.2.00.1001110844110.25601@tundra.namei.org>
References: <20091227010441.GA12077@heat> <20091227010650.GA12190@heat> <20091230185053.GB18712@us.ibm.com> <20100101143100.GA3944@atrey.karlin.mff.cuni.cz> <alpine.LRH.2.00.1001110811350.25601@tundra.namei.org> <20100110211609.GC26079@elf.ucw.cz>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Pavel Machek wrote:

> > > For the record: NAK, as it introduces security holes.
> > 
> > Please elaborate.
> 
> See the mailthread.

Yep, wading through several weeks of it..

> 
> Allows user to disable suid program's access to network. That bypasses
> audit, and will cause system-wide DoS if suid program decides to go
> daemon.

Ok.

-- 
James Morris
<jmorris@namei.org>
