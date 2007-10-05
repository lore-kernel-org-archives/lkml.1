Return-Path: <linux-kernel-owner+w=401wt.eu-S1764326AbXJEXrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764326AbXJEXrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761144AbXJEXr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:47:28 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:41450 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761390AbXJEXr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:47:27 -0400
Date: Sat, 6 Oct 2007 01:47:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Cute feature: colored printk output
In-Reply-To: <m3r6k9xi2d.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0710060137520.21791@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
 <m3r6k9xi2d.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 6 2007 01:22, Krzysztof Halasa wrote:
>Jan Engelhardt <jengelh@computergmbh.de> writes:
>
>> +	The value you need to enter here is the ASCII color value
>
>ASCII color value? ANSI perhaps?

ANSI:

\e[31m R--
\e[32m G--
\e[33m RG- (yellow)
\e[34m --B
\e[35m R-B (magenta)
\e[36m -GB (cyan)
\e[37m RGB (white)

ASCII:

1 --B blue
2 -G- green
3 -GB cyan
4 R-- red

...

e.g. just the other way around. 0x17 is gray-on-blue, what I use,
so it's ASCII actually. Quite confusing, yes. :-/

>composed ...

yes, should reword that.

>> +	Using "highlight foreground" is said not work when you use
>
>I'd say "HF is known not to work with VGA console" or just
>"HF doesn't work with VGA console".
>
>I wonder how accurate is it.

Since I do not use 512-glyph fonts, I do not know.
I suppose no, since that is what is written in the manpages or so.

With FB where the hardware draws the font, I do not know either,
I suppose yes.

With FB where the software draws the font (read: fbiterm with CJK),
it worked as usual, last time I tested.
