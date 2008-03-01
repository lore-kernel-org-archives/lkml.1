Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYCAVaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYCAVaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 16:30:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbYCAV3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 16:29:55 -0500
Received: from web36615.mail.mud.yahoo.com ([209.191.85.32]:31536 "HELO
	web36615.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753728AbYCAV3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 16:29:54 -0500
X-YMail-OSG: Od0a2L0VM1kFgZPklci5rr96mRCmJtS908y9JYCCGlEEDJ0wCqILYOqbQhfvYQtTKbCOnB0K_w--
X-RocketYMMF: rancidfat
Date: Sat, 1 Mar 2008 13:29:53 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [RFC PATCH -mm] LSM: Add lsm= boot parameter
To: Adrian Bunk <bunk@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, LKML <linux-kernel@vger.kernel.org>,
       LSM-ML <linux-security-module@vger.kernel.org>
In-Reply-To: <20080301211108.GF25835@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <674864.46980.qm@web36615.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Adrian Bunk <bunk@kernel.org> wrote:

> On Sat, Mar 01, 2008 at 12:28:43PM -0800, Casey Schaufler wrote:
> > 
> > --- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:
> > 
> > > Hi everybody,
> > > 
> > > This is a first try of adding lsm= boot parameter. 
> > > 
> > > Current situation is:
> > > 1- Ignore wrong input, with a small warning to users.
> > > 2- If user didn't specify a specific module, none will be loaded
> > 
> > I'm not fond of this behavior for the case where only one LSM
> > has been built in. Fedora, for example, ought to boot SELinux
> > without specifing lsm=SELinux, and all the rest should boot
> > whatever they are built with. In the case where a kernel is
> > built with conflicting LSMs (today SELinux and Smack) I see
> > this as a useful way to decide which to use until you get
> > your kernel rebuilt sanely, so it appears to be worth having.
> >...
> 
> Remarks:
> 
> Your comment would be covered if the default for this boot parameter (if 
> not explicitely set through the boot loader would not be "disabled" but 
> set through kconfig (based on the selected LSMs).

Agreed.

> We should really get this resolved for 2.6.25.

Agreed.

> security= suggestion is IMHO more intuitive than lsm=

security is a very overloaded term, but since this is one
of the ways it's already loaded in I could be OK with that.


Casey Schaufler
casey@schaufler-ca.com
