Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbXFYNvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbXFYNvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbXFYNuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:50:54 -0400
Received: from web36610.mail.mud.yahoo.com ([209.191.85.27]:43588 "HELO
	web36610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756346AbXFYNux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:50:53 -0400
X-YMail-OSG: fo05iGsVM1n4KqiLtSvxvoIs8mJuIpOPahb3hMbnbbTEuVOav3QOatFzf9fnHTKyGw--
X-RocketYMMF: rancidfat
Date: Mon, 25 Jun 2007 06:50:52 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
To: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, Andrew Morton <akpm@google.com>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <20070625035743.GA8786@vino.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <350610.33706.qm@web36610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting James Morris (jmorris@namei.org):
> > Convert LSM into a static interface, as the ability to unload a security 
> > module is not required by in-tree users and potentially complicates the 
> > overall security architecture.
> > 
> > Needlessly exported LSM symbols have been unexported, to help reduce API 
> > abuse.
> > 
> > Module parameters for the capability and root_plug modules have been
> > converted to kernel parameters.
> > 
> > The SECURITY_FRAMEWORK_VERSION macro has also been removed.
> 
> Sigh, as much as I would *like* to stay out of this (I don't
> use modules at all on any system where I can avoid it), won't
> it make development - and especially testing - of new lsms
> much more painful and therefore less likely?

While there's lots of pain involved in developing an LSM
modern development environments (e.g. virtual machines)
have reduced the value of loadable modules for debug purposes.

> I realize there has been a dearth of new LSMs to date,

but so much excitment over those proposed!

> but if
> for instance a new solaris 10 based capability module were written,
> well, people would want to be able to
> 
> 	rmmod capability
> 	modprobe cap_prm

I think the value is overrated. You would never want to do that
in a production environment, and in a debug environment you could
just as easily reboot and get some start-up testing out of the way.


Casey Schaufler
casey@schaufler-ca.com
