Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbXJ3Jm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbXJ3Jm0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbXJ3JmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:42:18 -0400
Received: from ns.firmix.at ([62.141.48.66]:5284 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXJ3JmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:42:17 -0400
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to
	static interface)
From: Bernd Petrovitsch <bernd@firmix.at>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>, Adrian Bunk <bunk@kernel.org>,
       Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <2c0942db0710250904n71a6c3dfk5dbc2a91f457ab05@mail.gmail.com>
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	 <1193303990.18559.28.camel@tara.firmix.at>
	 <2c0942db0710250904n71a6c3dfk5dbc2a91f457ab05@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Tue, 30 Oct 2007 10:41:23 +0100
Message-Id: <1193737283.6574.27.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.313 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.313 required=5
X-Spam-Score: -2.313 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 09:04 -0700, Ray Lee wrote:
> On 10/25/07, Bernd Petrovitsch <bernd@firmix.at> wrote:
> > On Mit, 2007-10-24 at 17:35 -0700, Ray Lee wrote:
> > [....]
> > > Key-based masterlocks are easily broken with freon, and their combo
> > > locks are easily brute-forced in about ten minutes. Yet, I'll still
> > > use them to lock up my bike and garage.
> >
> > The question is what the security threat is and the value of the secured
> > items.
> >
> > > The idea that poor security is worse than no security is fallacious,
> > > and not backed up by common experience.
> >
> > The common experience is, that common people just *feel* safer (just
> > because they have poor security).
> 
> Do you lock your bike up when you leave it lying around? My point is
> that real security comes in layers, not one perfect solution that will
> always work everywhere for everyone. The latter is a pipe-dream.

Of course not. "Security" as such is more than less "only" risk
management (or part of it - depending of the viewpoint).

> > With no security, they know that there is no security. With poor
> > security, they do not know (or can deny) that they have next to no real
> > security.
> 
> The fallacy here is to believe that just because they have no
> security, that it will *in*any*way* change their behavior. I deal with
> real users daily, and *they*don't*care*. Further, there's no level of

If people don't care, they are pretty lost anyway.
That's actually the reason for all that security stuff that no one wants
but which stands in the way of all people just because of the "don't
care" faction (which by far the majority of all in any given area).
But there is that (also not too small) "I installed $PERSONAL_FIREWALL
and *nothing* can happen because $VENDOR and $TECH_JOURNALIST in
$LOW_QUALITY_PC_MAG said so" faction.

> education that we can instill into the community to make them aware of
> the issues and change their habits accordingly, because real users
> don't have the background to understand those lessons.
> 
> While you can teach them that running an executable from someone they
> haven't heard of is obviously bad, they don't know why downloading an
> image is potentially dangerous, "it's an image, right?" "Well, there's
> these things called buffer overflows..." <eyes glaze over>
> 
> Security is not an all or nothing game, it's layers. And we have to

And every layer/subsystem/area must be checked and seen independently of
others (or the dependency must be that strong that no one can work
around).
And every security layer will and should have it's purpose and targets.

> make sure that the layers are usable without taking a course from the
> NSA. I'd love to see a poll of the kernel development community to
> find out how many use SELinux on their machines, for example.

"selinux=0" on the kernel commandline is normal - no unknown people have
logins and so there was no reason to learn it. And against should it
protect in the first place if only trusted people are there?

> > The prime example here is the usual (so-called) "personal firewall" on
> > Windows where people work normally as "administrator".
> 
> So your argument is that if there weren't a personal firewall on
> Windows, that a significant number of people would then not run as
> Administrator? I beg to differ.

No, how do you come to that conclusion?

People login as "Administrator" because they did it since DOS3.0.
People buy and install $PERSONAL_FIREWALL because some cheap PC tech
magazine had advertisements for them.
Next generation (or this generation?) viruses/malware will either
reconfigure $PERSONAL_FIREWALL silently (and if course only
temporarily).
And the vendor of $PERSONAL_FIREWALL writes into the manual (which no
one reads) or the EULA (which no one reads because it isn't relevant in
the first place) or some README (which no one finds) that one must not
login as "Administrator". But that just to keep the vict^Wbuyers to not
sue them. And working on Win* without being "Administrator" is a real
PITA - so the average user won't do it for long.

So apart from the personal feelings of that user I can't find any sign
of security.

BTW from a commercial viewpoint, the (so-called) "personal firewalls"
were probably one of the best ideas (and another major example that
technical expertise has nothing to do with sales success).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

