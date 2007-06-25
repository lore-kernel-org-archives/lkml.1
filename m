Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbXFYJwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbXFYJwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXFYJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:52:04 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:42456 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXFYJwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:52:01 -0400
Date: Mon, 25 Jun 2007 11:51:59 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <20070624215724.025a5de5@the-village.bc.nu>
Message-ID: <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <20070624215724.025a5de5@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1112603535-1182765119=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1112603535-1182765119=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Sun, 24 Jun 2007, Alan Cox wrote:

>> Sory Alan but I don't want philosophical/historical discuss.
>> Try to answer on question "ALSA or OSS ?" using *only* technical arguments.
>
> We dropped OSS for ALSA for technical reasons. Those being that ALSA
> - has a better audio API

How better and where better ?
Please be more verbose :>

> - is more flexible

Yes .. if you have API with thin abstracttion (like ALSA has) theoreticaly 
you can do more but also by lack of some abstraction normal/usual things 
must be implemented in harder way. This was theory .. pracice is completly 
diffrent because some applications still provides better soud support 
(without interruption) when uses OSS emulation placed on top ALSA layer 
than compiled for direct use ALSA API.

Sound it in not rocket science. In 99.9% cases you need well abstracted 
API which ALSA doe not provide and this is real cause why so poor sound 
support in Linux applications is. Thin ALSA abstraction is main cause of 
avalaibability "tons" of additional soud user space APIs.
"Nice" plot with current situation you can see on:
http://blogs.adobe.com/penguin.swf/linuxaudio.png

On above blog with this picture you can find more arguments against ALSA. 
Your "more flexible" API in this case mean "ALSA provides only 
atomic/elentar API". Result: look on for example GNOME mixer (or alsa-util 
term based mixer). After each change soud card type in your computer you 
will see changes in triggers set. More .. your "more flexible" API does 
not provides usualy expected soud adjustmets parameters like volume level, 
central balance .. but instead provides PCM level. Try go on street 
(sometimes) and ask some PC users or someone who have at home audio 
devices like TV/radio/whatever and ask them "what is it f* PCM ?".
Yes .. ALSA provides "more flexible API" if you want "fly using glider 
have only raw pieces of wood" .. not if you want just fly and nothing 
more.

On http://blogs.adobe.com/penguin.swf/ you can see also calling for better 
abstracted API.

> - provides OSS as emulation

OSS provides ALSA emulation too.
Sorry but for me there is no technical argument.

> - supports more hardware

Please .. talk obout/back to ALSA/OSS API/KAPI compare.

> I used to maintain the kernel OSS code (the fork when Hannu and friends
> took their project non-free). I did the work to make the sound layer
> modular when the vendors realises that the open one needed to be modular
> and that since that was the main play of the non-free one that Hannu
> wasn't going to be doing it. From a technical perspective ALSA is the
> better design especially for flexible devices.

Look at Hannu blog and grab more arguments against ALSA:
http://www.4front-tech.com/hannublog/

To above I can only add again my argumet (which you saw more than year ago 
and still is without response): ALSA does not provide secure way for manage
sound device on mixing level.

> At the desktop level these days it doesn't really matter much, the
> desktops use their own sound servers which sit on top of OSS, ALSA and
> other sound systems.

So .. why ALSA provides so thin API if in most cases applications 
want only open soud device and/or in some more sohisticated case soud 
device in stere, 4+1, 5+1 or so mode  .. why provide API which not 
provides this expected functionalities in easy way ?
Bad/poor design or API planning or not well educated programmers or maybe 
ALSA still is developed by "belivers" (not enginers) who don't beleve in 
"soft mixing in kernel space isn't possible/secure" (even if it is 
provided in OSS) ?

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1112603535-1182765119=:25800--
