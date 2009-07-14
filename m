Return-Path: <linux-kernel-owner+w=401wt.eu-S1754320AbZGNJwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320AbZGNJwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZGNJwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:52:43 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:54382 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbZGNJwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:52:42 -0400
Date: Tue, 14 Jul 2009 11:52:41 +0200
From: Andreas Mohr <andi@lisas.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc2: X stop accepting keystrokes?
Message-ID: <20090714095241.GA26272@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714092459.GA2010@elf.ucw.cz>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having very similar issues currently, on two of my systems now
(used to be one only for months, now the second one started having the
same issues about 4 weeks ago, with no recognizable config change).

Symptoms are that I keep swearing over the system mixing up special key
state (Ctrl, Alt, AltGr, etc.), resulting in all sorts of awful
actions such as shell logout, view switch, going back to tty, killing
text etc.pp.
And sometimes full lockup of keyboard in X.

Interestingly, while trying to fix it, KDE 4.2.2 systemsettings did NOT
manage to get my keyboard back when resetting keyboard or mouse dialog
state. HOWEVER, switching screen resolution in the graphics
configuration section DID get my keyboard back!
Installing entire armadas of xkb*, xinput* packages/utilities had NOT
managed to do so...

First system: Desktop, 2.6.30-rc5, Debian testing or unstable, PS/2 keyboard,
tweaked xorg.conf (--> HAL input unknown).
Second system: Netbook, Acer Aspire One, 2.6.30(.0), u9.04, PS/2 internal,
no xorg.conf (--> HAL input?).

Interesting (if rather non-clueful) pages are
https://wiki.ubuntu.com/X/Troubleshooting/HalBreaksKeyboardAndMouse
https://wiki.ubuntu.com/X/Config/Input

Or it could just really be something strongly kernel-specific for you
and something entirely unrelated to the pages and problems above.

Come to think of it, I had some full-keyboard-lockup situation(s)
even earlier on my netbook (maybe as far back as 6 weeks?),
thus it might actually be my recent kernel update indeed.

And rest assured that it's annoying as hell. :P

Andreas Mohr
