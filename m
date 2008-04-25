Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbYDYQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbYDYQqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761150AbYDYQqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:46:03 -0400
Received: from mail.AKNET.ru ([77.246.241.226]:62939 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759942AbYDYQqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:46:01 -0400
Message-ID: <48120ABF.1050802@aknet.ru>
Date: Fri, 25 Apr 2008 20:45:51 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-mm1 (snd-pcsp doesn't like DEBUG_PAGEALLOC)
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>	<20080419021343.GA3503@nineveh.local>	<20080418200237.b5a9e805.akpm@linux-foundation.org>	<20080419041429.GA8508@anvil.corenet.prv>	<20080418212934.bbe84ee2.akpm@linux-foundation.org>	<s5h8wz7cng7.wl%tiwai@suse.de>	<480CD50F.20706@aknet.ru>	<s5hbq42b3j7.wl%tiwai@suse.de>	<480E2EE5.5040208@aknet.ru>	<s5hiqy9dkhv.wl%tiwai@suse.de>	<480F95BE.60109@aknet.ru>	<s5h3apbd1zx.wl%tiwai@suse.de>	<4811555E.3040509@aknet.ru> <s5hfxta4fem.wl%tiwai@suse.de>
In-Reply-To: <s5hfxta4fem.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Takashi Iwai wrote:
> Yeah, of course.  Don't mix up with the argument about Kconfig
> dependency issues.  I just reacted against your statement that input
> pcspkr driver will be obsoleted.
Those are the different ones of course.
For me the dependancy issue is a primary
problem of course, so the other one I
simply ducked.

> I actually removed the dependency from snd-pcsp Kconfig again since
> this causes a dependency loop (at least, kbuild can't handle
> properly). 
OK, good to know this. :)

> But anyway, as mentioned in my previous post, snd-pcsp wouldn't be
> enabled on most of distros' kernels because it cannot be built
> together with input-pcspkr driver, unfortunately...
Yes, making them to play well together is
something to think about too. But I don't
see how it can affect the distributors.
If the distro doesn't have the sound enabled,
then it won't enable snd-pcsp no matter
what. If it does have the sound enabled,
then why would it ever want to use pcspkr
instead of snd-pcsp?
I see this issue mostly as a theoretical
one. If you see the real problems with
the current situation, please let me know.
