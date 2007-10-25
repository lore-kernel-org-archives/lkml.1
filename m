Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbXJYBm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbXJYBm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 21:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXJYBmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 21:42:19 -0400
Received: from web36604.mail.mud.yahoo.com ([209.191.85.21]:23751 "HELO
	web36604.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753009AbXJYBmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 21:42:17 -0400
X-YMail-OSG: VYe1MeoVM1ltuhUt3.DgafmwEGJ5n_Q27CYvQWrN5ikm1yOlgBfe9kT6pA6zq.8ufyGCeMR4Kw--
X-RocketYMMF: rancidfat
Date: Wed, 24 Oct 2007 18:42:15 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
To: Chris Wright <chrisw@sous-sol.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20071025002356.GB3660@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <183239.5113.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Chris Wright <chrisw@sous-sol.org> wrote:

> * Casey Schaufler (casey@schaufler-ca.com) wrote:
> > And don't give me the old "LKML is a tough crowd" feldercarb.
> > Security modules have been much worse. Innovation, even in
> > security, is a good thing and treating people harshly, even
> > "for their own good", is an impediment to innovation.
> 
> I agree that innovation is critical to the success of Linux, and security
> is not immune to that.  The trouble is that most of the security modules
> that have come forward have had some real serious shortcomings.  I do
> believe it is prudent to keep in-tree security sensitive code under
> high scrutiny because we do not want to create security holes by adding
> problematic security code.

I agree that security code does need to provide security. What we
need to get away from is the automatic attacks that are based on 20th
century computer system assumptions. Things like "name based access
control is rediculous", and "a module can't be any good if it doesn't
deal with all objects", or "the granularity isn't fine enough". Look
at TOMOYO. It's chuck full of good ideas. Why spend so much energy
badgering them about not dealing with sockets? How about helping the
AppArmor crew come up with acceptable implementations rather than
whinging about the evils of hard links? And maybe, just maybe, we can
get away from the inevitable claim that you could do that with a few
minutes work in SELinux policy, but only if you're a security
professional of course.

Sure, some LSM proposals will be lousy, and some really will be
better done as an SELinux policy module. Some will even have merit
but require unreasonable interface changes. As people who care
about security (y'all who are only from the LKML are excused) it
is our obligation to look beyond the preconceived notions of what
is and isn't secure. Security is subjective. It's how you feel
about it.



Casey Schaufler
casey@schaufler-ca.com
