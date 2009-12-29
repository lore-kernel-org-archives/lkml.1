Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZL2VKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZL2VKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 16:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZL2VKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 16:10:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46798 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752409AbZL2VKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 16:10:44 -0500
Date: Tue, 29 Dec 2009 21:11:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Benny Amorsen <benny+usenet@amorsen.dk>, Bryan Donlan <bdonlan@gmail.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
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
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: RFC: disablenetwork facility. (v4)
Message-ID: <20091229211139.0732a0c1@lxorguk.ukuu.org.uk>
In-Reply-To: <m17hs5y0mg.fsf@fess.ebiederm.org>
References: <20091229050114.GC14362@heat>
	<m1y6km11lj.fsf@fess.ebiederm.org>
	<20091229151146.GA32153@us.ibm.com>
	<3e8340490912290805s103fb789y13acea4a84669b20@mail.gmail.com>
	<m3oclhzgm4.fsf@ursa.amorsen.dk>
	<m17hs5y0mg.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Execute != read. The executable file may contain secrets which must not
> > be available to the user running the setuid program. If you fail the
> > setuid, the user will be able to ptrace() and then the secret is
> > revealed.
> >
> > It's amazing how many security holes appear from what seems like a very
> > simple request.
> 
> Do we have a security hole in nosuid mount option?
> Can someone write a patch to fix it?

If a setuid app can read a key when its erroneously not set setuid then
the user can read it too.

Anything you can do with ptrace you can do yourself !
