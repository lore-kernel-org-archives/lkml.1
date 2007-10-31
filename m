Return-Path: <linux-kernel-owner+w=401wt.eu-S1756094AbXJaGmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbXJaGmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbXJaGmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:42:25 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:60203 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753028AbXJaGmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:42:23 -0400
Message-ID: <472823FA.80303@crispincowan.com>
Date: Tue, 30 Oct 2007 23:43:06 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Peter Dolding <oiaohm@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>	 <4726377A.4080807@crispincowan.com>	 <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>	 <Pine.LNX.4.64.0710301136560.31325@fbirervta.pbzchgretzou.qr>	 <4727C06A.4060005@gmail.com>	 <Pine.LNX.4.64.0710301713260.8703@asgard.lang.hm> <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
In-Reply-To: <e7d8f83e0710301921m3460f8dfkce72c4fc549ded4a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Dolding wrote:
> Lets end the bitrot.  Start having bits go into the main OS security
> features where they should be.
>   
Linus categorically rejected this idea, several times, very clearly.

He did so because the security community cannot agree on a
one-true-standard for what that OS security feature set should be. From
looking at this thread and many others, he is correct; there is no
consensus on what the feature set should be.

So you can wish for the "main OS security features" all you want, but it
is not going to happen without a miraculous degree of consensus abruptly
arising.

On the contrary, security, done well, is a tight fitting suit. It must
be tight, or it allows too much slack and attackers can exploit that. To
make it tight, it must be tailored to the situation at hand. That means
that there may *never* be a consensus on the "one true way", because it
could be that there is no "one true way". It could be that SMACK is best
in some cases, AppArmor in others, SELinux in others yet again, MLS in
others, etc. etc.

I agree with Casey; LSM may not be perfect, but it is a great deal more
consensus than I have seen anywhere else in the security community. Your
desire that AppArmor and SELinux should share code has already happened:
LSM *is* the sharable code base between AppArmor, SELinux, and SMACK and
TOMOYO, and MultiADM, etc.

It certainly can be improved, but it is not in need of wholesale
replacement, and especially not without a clear design that addresses
clearly stated problems that lots of people are having.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

