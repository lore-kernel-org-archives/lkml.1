Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbXKZQR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbXKZQR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:17:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbXKZQRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:17:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:33801 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbXKZQRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:17:19 -0500
Date: Mon, 26 Nov 2007 17:17:18 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
In-Reply-To: <alpine.LFD.0.9999.0711261110040.25316@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0711261716220.22369@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
 <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com>
 <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.9999.0711261048050.24142@localhost.localdomain>
 <Pine.LNX.4.64.0711261704070.19299@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.9999.0711261110040.25316@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 26 2007 11:13, Robert P. J. Day wrote:
>> >>>Only on current machines. You'd break building kernel RPMs on older
>> >>>systems that don't have rpmbuild installed.
>> >>
>> >> Those old machines probably do not even run a distro-fabricated
>> >> gcc that would compile a git head kernel.
>> >
>> >well, in a nutshell, the problem scenario is that it's entirely
>> >possible to have a modern distro (say, fedora 8, like i'm using) on
>> >which you have the latest "rpm" package installed, but not
>> >"rpmbuild".
>>
>> What, modern and no rpmbuild?
>
>i didn't say it *wouldn't* have rpmbuild, i said it *might not*.  at
>the moment, on my f8 system, the only package that requires the
>rpm-build package is rpmdevtools, and it's entirely possible that
>there's no need for *that* package.

rpm -b does not work in opensuse anymore (redirects you to use rpmbuild), and I
bet fedora will do the same, so if you don't have rpm-build, tough luck for
make rpm.

>so all i'm suggesting is that the
>build procedure take into account the possibility that rpm-build is
>not installed.
