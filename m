Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZLMLJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZLMLJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZLMLJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:09:13 -0500
Received: from borg.medozas.de ([188.40.89.202]:47419 "HELO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752409AbZLMLJM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:09:12 -0500
Date: Sun, 13 Dec 2009 12:09:09 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Nir Tzachar <nir.tzachar@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: nconfig v7
In-Reply-To: <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>
Message-ID: <alpine.LSU.2.01.0912131118280.28039@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.0912112023170.32039@obet.zrqbmnf.qr> <9b2db90b0912122323w25d2d815o70d0bd2f1e19a228@mail.gmail.com>
User-Agent: Alpine 2.01 (LSU 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday 2009-12-13 08:23, Nir Tzachar wrote:
>On Fri, Dec 11, 2009 at 9:55 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> Hi,
>>
>>
>> I gave nconfig a try, and here are a few suggestive points:
>
>10x ;)

Ten times what?

>> - provide the same color scheme as menuconfig
>
>As far as colrs are involved, I think it is best to not impose any
>color scheme. You can never satisfy everyone, and will get into
>endless fights about which is best.

Well, menuconfig seems to have had the least fights. There was exactly 
one color scheme imposed, and that did not change for years; when themes 
were added, not much happened. There was a bit of discussion and 
submissions about themes (including myself), but in the end, it was 
sort-of agreed upon that four were enough. And they seem to work for 
everybody.

>I believe the current approach in nconfig works best, as I am using 
>the default terminal colors for the main body of text (menus, help 
>text, etc), and only use colors for emphasis (headings, boxes, etc). 

No sorry. Black-on-blue does not work very much, for the physical fact 
that blue is recognized as faint. Let me put in some numbers (30,59,11% 
are the common RGB weighting for grayscale/luminance)

 Blue:                       Effective Lum:
 - xterm standard (#0000EE): 26.18
 - VGA standard (#0000AA):   18.70
 Cyan:
 - VGA (#00AAAA)             119.00

So you see why Midnight Commander, htop, etc. all use Black-on-Cyan for 
their Fn keybar instead of Blue.

>This is based on the belief that users have already chosen the colors 
>which work best for them, and are already using them in their teminal's 
>config.
>
>> - I get a visual glitch (see Exhibit A below) in General setup (patch
>>  slapped onto 2.6.32); the left frame part is missing.
>
>I cannot reproduce this. Can you provide some more details? (e.g.,
>which terminal, $LINES, $COLUMNS, $TERM)

xterm -bg black -fg gray -geometry 80x25


>> - I certainly like F4-Config-ShowAll :)  but it has some glitches
>>  interfering near ARCH_DEFCONFIG (see Exhibit B).
>
>Thanks for catching this. It is a by-product of the code for
>presenting everything inside a single menu. Easily fixed in the next
>version. By the way, is anyone using this option at all? It would much
>simplify the code if I did not have to support the one giant menu
>option.

Well nconfig is the first to provide that option. (Note: I don't use 
gconfig or xconfig, so I cannot tell if they have something like that.)
So to see whether there is use, you would have to wait a number of 
kernel releases that have nconfig integrated.
