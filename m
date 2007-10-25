Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbXJYQFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbXJYQFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757759AbXJYQFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:05:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:7910 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761317AbXJYQFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:05:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=hAzBuUHX2WfVrsk75KyggC6AosIrK1z24f0Umj9VzHH7ey6V5uQ48OgdnSF1ca4lxv7JABtpJLhM73FYzbpFY6fQwd20kDYdlLS6KwluyBaa92iVcMk1emohbZ9J82NwuemR4ZiTCSXLNa65BceUvIGuoUrecG+3Ynrb1mQ5O/w=
Message-ID: <2c0942db0710250904n71a6c3dfk5dbc2a91f457ab05@mail.gmail.com>
Date: Thu, 25 Oct 2007 09:04:57 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Bernd Petrovitsch" <bernd@firmix.at>
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static interface)
Cc: "Chris Wright" <chrisw@sous-sol.org>,
       "Casey Schaufler" <casey@schaufler-ca.com>,
       "Adrian Bunk" <bunk@kernel.org>, "Simon Arlott" <simon@fire.lp0.eu>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "Thomas Fricaccia" <thomas_fricacci@yahoo.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "James Morris" <jmorris@namei.org>,
       "Crispin Cowan" <crispin@crispincowan.com>,
       "Giacomo Catenazzi" <cate@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1193303990.18559.28.camel@tara.firmix.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071024223124.GI30533@stusta.de>
	 <446110.89443.qm@web36608.mail.mud.yahoo.com>
	 <20071025002356.GB3660@sequoia.sous-sol.org>
	 <2c0942db0710241735j78cfbec9rd8b5128d5da1fb96@mail.gmail.com>
	 <1193303990.18559.28.camel@tara.firmix.at>
X-Google-Sender-Auth: b897fb43a3bd7194
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/07, Bernd Petrovitsch <bernd@firmix.at> wrote:
> On Mit, 2007-10-24 at 17:35 -0700, Ray Lee wrote:
> [....]
> > Key-based masterlocks are easily broken with freon, and their combo
> > locks are easily brute-forced in about ten minutes. Yet, I'll still
> > use them to lock up my bike and garage.
>
> The question is what the security threat is and the value of the secured
> items.
>
> > The idea that poor security is worse than no security is fallacious,
> > and not backed up by common experience.
>
> The common experience is, that common people just *feel* safer (just
> because they have poor security).

Do you lock your bike up when you leave it lying around? My point is
that real security comes in layers, not one perfect solution that will
always work everywhere for everyone. The latter is a pipe-dream.

> With no security, they know that there is no security. With poor
> security, they do not know (or can deny) that they have next to no real
> security.

The fallacy here is to believe that just because they have no
security, that it will *in*any*way* change their behavior. I deal with
real users daily, and *they*don't*care*. Further, there's no level of
education that we can instill into the community to make them aware of
the issues and change their habits accordingly, because real users
don't have the background to understand those lessons.

While you can teach them that running an executable from someone they
haven't heard of is obviously bad, they don't know why downloading an
image is potentially dangerous, "it's an image, right?" "Well, there's
these things called buffer overflows..." <eyes glaze over>

Security is not an all or nothing game, it's layers. And we have to
make sure that the layers are usable without taking a course from the
NSA. I'd love to see a poll of the kernel development community to
find out how many use SELinux on their machines, for example.

> The prime example here is the usual (so-called) "personal firewall" on
> Windows where people work normally as "administrator".

So your argument is that if there weren't a personal firewall on
Windows, that a significant number of people would then not run as
Administrator? I beg to differ.

Ray
