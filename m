Return-Path: <linux-kernel-owner+w=401wt.eu-S1756472AbXKZQGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472AbXKZQGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbXKZQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:05:53 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35256 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbXKZQFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:05:52 -0500
Date: Mon, 26 Nov 2007 17:05:51 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
cc: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
In-Reply-To: <alpine.LFD.0.9999.0711261048050.24142@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0711261704070.19299@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain>
 <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com>
 <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.9999.0711261048050.24142@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 26 2007 10:53, Robert P. J. Day wrote:
>
>>>Only on current machines. You'd break building kernel RPMs on older
>>>systems that don't have rpmbuild installed.
>>
>> Those old machines probably do not even run a distro-fabricated gcc that
>> would compile a git head kernel.
>
>well, in a nutshell, the problem scenario is that it's entirely
>possible to have a modern distro (say, fedora 8, like i'm using) on
>which you have the latest "rpm" package installed, but not "rpmbuild".

What, modern and no rpmbuild?

AFAIR, it had rpmbuild back to at least FC6, it's not that new this rpmbuild.

>at which point scripts/package/Makefile, based on this:
>
>RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
>                   else echo rpm; fi)
>
>will select "rpm" as the value of the variable RPM, at which point
>things go south in a hurry as soon as you try to build an rpm package
>using $(RPM) aka "rpm".
>
>perhaps a solution would be to have two variables -- RPM and RPMBUILD
>-- and set them appropriately based on what the Makefile finds.  and,
>of course, whine incessantly if you have an unworkable setup.
>
>anyway, have at it.
