Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbXJ3DXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbXJ3DXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 23:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752526AbXJ3DXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 23:23:34 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:49011 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbXJ3DXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 23:23:33 -0400
Message-ID: <4726A3A2.7060205@nttdata.co.jp>
Date: Tue, 30 Oct 2007 12:23:14 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: casey@schaufler-ca.com
CC: Chris Wright <chrisw@sous-sol.org>, Adrian Bunk <bunk@kernel.org>,
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
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <183239.5113.qm@web36604.mail.mud.yahoo.com>
In-Reply-To: <183239.5113.qm@web36604.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Oct 2007 03:23:16.0532 (UTC) FILETIME=[36239740:01C81AA4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2007 10:42 AM, Casey Schaufler wrote:
> I agree that security code does need to provide security. What we
> need to get away from is the automatic attacks that are based on 20th
> century computer system assumptions. Things like "name based access
> control is rediculous", and "a module can't be any good if it doesn't
> deal with all objects", or "the granularity isn't fine enough". Look
> at TOMOYO. It's chuck full of good ideas. Why spend so much energy
> badgering them about not dealing with sockets? How about helping the
> AppArmor crew come up with acceptable implementations rather than
> whinging about the evils of hard links? And maybe, just maybe, we can
> get away from the inevitable claim that you could do that with a few
> minutes work in SELinux policy, but only if you're a security
> professional of course.

Casey,

Thank you introducing TOMOYO Linux. I really like your idea of
simplified MAC (and you work so hard!). I also find advantages
of AppArmor for distributing policies with less hustle. Finally
and most importantly, I respect SELinux as the first in-tree,
flexible and reliable security frame work and respect developers
involved.

As a project manager of TOMOYO Linux, I would like to
push it, of course. But I noticed, if each of LSM module
developer begin pushing their own code, that's not for the
sake of Linux and we may end up with chaos.

Instead of pushing TOMOYO Linux, I started developing
comparison chart of security-enhance Linux implementations.
The current version can be found in

http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison

I would like to receive feedbacks from Stephen, Crispin
(you already have a comparison, though :),
Casey and any people interested in. If possible,
I would like to include opinions from BSD people.

I would like LSM to be the result of common requirements.
"Common" means good in general, but not always for security
perspective. IMHO, I think it is possible for us to get to the
conclusion not to have a framework.

Cheers (and with love to Linux),
Toshiharu Harada

