Return-Path: <linux-kernel-owner+w=401wt.eu-S1761860AbYAHQf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761860AbYAHQf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 11:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYAHQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 11:35:17 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:48028 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYAHQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 11:35:15 -0500
Date: Tue, 8 Jan 2008 17:35:14 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tuomo Valkonen <tuomov@iki.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
Message-ID: <Pine.LNX.4.64.0801081725480.3032@fbirervta.pbzchgretzou.qr>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8 2008 16:07, Tuomo Valkonen wrote:
>
>One should always indicate the version of software when complaining. Well,
>
>    $ uname -a
>    Linux noi 2.6.14 #1 PREEMPT Sun Oct 30 20:18:48 EET 2005 i686 GNU/Linux
>
>I've tried upgrading, and failed: the megatonne monolith with a gazillion
>hidden options (and totally worthless make oldconfig) is impossible to
>compile these days,

Do it step-by-step.

git checkout v2.6.15
make oldconfig
git checkout v2.6.16
make oldconfig
...

>and the distros' stock kernel are utter and total crap

I can recommend that you try another distribution then.

>that load drivers in wrong order etc.,

What specific modules and which order do you need for the disks?
There is also kernel-side loading order coming up:
http://lwn.net/Articles/260856/

>and are difficult to configure

I do not really have to configure anything on my machine. Then again,
yours might be vastly different. I can seamlessy switch distro and
self-built kernels, with the only extra that I have to call mkinitrd
(on opensuse that works without arguments even) for the self-built one.

>(demanding crap that demands udev to edit their initrds).

mkinitrd should take care of that.
