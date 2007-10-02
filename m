Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbXJBXCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbXJBXCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbXJBXB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:01:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58387 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbXJBXBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:01:55 -0400
Date: Wed, 3 Oct 2007 01:01:54 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jimmy <lists@dusted.dk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Point of gpl-only modules (flame)
In-Reply-To: <4702BCD0.4010202@dusted.dk>
Message-ID: <Pine.LNX.4.64.0710030051350.28124@fbirervta.pbzchgretzou.qr>
References: <4702BCD0.4010202@dusted.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 2 2007 23:49, Jimmy wrote:
>
> Anyway, I've been trying to figure out what purpose the gpl-only code serves.
> What good comes out of disabling people from probing modules that do not have a
> gpl-compatible license?

find /lib/modules/`uname -r` -iname '*.ko' | wc -l:

	2021

Proprietary modules that I can think of:

	5 to 10

It's not even 1/2 a !#$ percent. (Though knowing that many modules are for
not-so-common hw.)

> It seems pretty childish to try and force some license on people, imagine
> trying to install firefox on Windows Vista, an error-dialog box appears:
> "This application has been denied access to the Windows API as its license are
> compatible with the Microsoft Philosophy" ?

Not a kernel problem.

(That said, MS would probably face yet another antitrust charge if it did that.
Or better yet, people would just thankfully stop using it.)

> Now, i don't want to waste clock cycles on executing code that serves no
> purpose but restraining me from using my $1500 gfx card as intended,

Perhaps you intended to buy a game console instead?

That said, no one is restraining you. You can edit the kernel source
and rip out all the GPL checks. On top, it's not like the ati or
nvidia blob-ola would not load in today's kernel.

01:00 ichi:~ > lsmod | grep nv
nvidia               4717076  22 

Oh yeah, my kernel (unpatched, btw) really tries to stop me hard
from loading it.

> so will me
> removing that crap from the source result in somebody trying to obfuscate it to
> a point where neither of us know what is what?
>
> Also, how about a list of PROS, explain to me whats so cool about it?
>
> - Jimmy
