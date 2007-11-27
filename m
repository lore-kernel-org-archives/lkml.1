Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXK0Nj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXK0Nj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 08:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXK0Njv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 08:39:51 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:40828 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXK0Nju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 08:39:50 -0500
Date: Tue, 27 Nov 2007 08:37:37 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
In-Reply-To: <Pine.LNX.4.64.0711261716220.22369@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.9999.0711270835380.21411@localhost.localdomain>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain> <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com> <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.9999.0711261048050.24142@localhost.localdomain>
 <Pine.LNX.4.64.0711261704070.19299@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.9999.0711261110040.25316@localhost.localdomain> <Pine.LNX.4.64.0711261716220.22369@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Jan Engelhardt wrote:

>
> On Nov 26 2007 11:13, Robert P. J. Day wrote:
> >> >>>Only on current machines. You'd break building kernel RPMs on older
> >> >>>systems that don't have rpmbuild installed.
> >> >>
> >> >> Those old machines probably do not even run a distro-fabricated
> >> >> gcc that would compile a git head kernel.
> >> >
> >> >well, in a nutshell, the problem scenario is that it's entirely
> >> >possible to have a modern distro (say, fedora 8, like i'm using) on
> >> >which you have the latest "rpm" package installed, but not
> >> >"rpmbuild".
> >>
> >> What, modern and no rpmbuild?
> >
> >i didn't say it *wouldn't* have rpmbuild, i said it *might not*.
> >at the moment, on my f8 system, the only package that requires the
> >rpm-build package is rpmdevtools, and it's entirely possible that
> >there's no need for *that* package.
>
> rpm -b does not work in opensuse anymore (redirects you to use
> rpmbuild), and I bet fedora will do the same, so if you don't have
> rpm-build, tough luck for make rpm.

i know that that's the case *now*, but we're considering the
possibility that someone is using an older system on which "rpm" is
*still* the builder.  in the end, all i'm suggesting is that the build
should work under all possible scenarios.

rday

p.s.  i'm not *trying* to make this issue more obfuscated or
convoluted than it has to be -- i am merely succeeding.

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
