Return-Path: <linux-kernel-owner+w=401wt.eu-S932329AbYEFQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbYEFQvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765834AbYEFQvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:51:33 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:61735 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765756AbYEFQvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:51:31 -0400
Message-ID: <48208C85.30606@aknet.ru>
Date: Tue, 06 May 2008 20:51:17 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru>	<s5hbq42b3j7.wl%tiwai@suse.de>	<480E2EE5.5040208@aknet.ru>	<s5hiqy9dkhv.wl%tiwai@suse.de>	<480F95BE.60109@aknet.ru>	<s5h3apbd1zx.wl%tiwai@suse.de>	<4811555E.3040509@aknet.ru>	<s5hfxta4fem.wl%tiwai@suse.de>	<48120ABF.1050802@aknet.ru>	<s5hve25j2tj.wl%tiwai@suse.de>	<s5habj8odtq.wl%tiwai@suse.de>	<481B47DC.1010605@aknet.ru> <s5hr6cfd99m.wl%tiwai@suse.de>
In-Reply-To: <s5hr6cfd99m.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> The case (c) was my proposal.  But in this case, the driver will
> become likely self consistent; it allocates its own device at init.
> In anyway, there is no sexy way to auto-load snd-pcsp (partly because
> it's the purpose -- avoid loading the sound subsystem unless really
> necessary).  That's why I called it hackish.
I thought all (or most) alsa drivers
are allocating device on init, even
though this is explicitly discouraged
in the docs. So I was considering this
as a possible solution with the minimal
drawback.
But... as long as the autoloading by
default is not needed, and both drivers
can be at least built together, and not
too much distros have pcspkr built-in,
I thought the current solution - having
pcspkr as the default but to let the user
to choose snd-pcsp, is not all that bad
too. I guess it costs only adding a single
alias into modprobe.conf to choose snd-pcsp.
And I also think _most_ distros do not
mind having the sound subsystem loaded
by default, but some certainly do. For
those that do, the user will have to add
an alias. For others - he may get snd-pcsp
right away. IMHO this is rather acceptable.
