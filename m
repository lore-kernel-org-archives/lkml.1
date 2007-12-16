Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbXLPTLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbXLPTLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 14:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbXLPTLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 14:11:37 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:47216 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbXLPTLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 14:11:36 -0500
Date: Sun, 16 Dec 2007 20:11:33 +0100
Message-Id: <49448787@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Matt.Domsch@dell.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX18Qxbgq5ZafHotdZFv73koVrouxkTeJeDR2/kf4iFyc5I6nq
 xU1y3lk24TD/sZZcK0SrNTl9BSmGWWIQQchscLcZ+27TrcJNXs=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It does not look like this issue is common - googling for "Linux EDD Boot 
> hang" does not bring up relevant and recent results - in fact this post of 
> yours comes on top.

i don`t wonder here - how should one know that it`s an edd problem if all he sees is a blank screen with a blinking cursor in the upper left ?
so i assume, "Linux EDD Boot hang" isn`t the best term for searching here.

i think, there is no universal search phrase - i found some references with different words (linux install, blank screen, blinking cursor....)

some of them
http://forums.suselinuxsupport.de/lofiversion/index.php/t61581.html
http://suseforums.net/index.php?showtopic=1302  
http://forums.suselinuxsupport.de/lofiversion/index.php/t3157.html
http://www.linuxforums.org/forum/installation/73984-cant-boot-past-loading-kernel-fedora-4-a.html
http://ubuntuforums.org/archive/index.php/t-146180.html
http://ubuntuforums.org/showthread.php?t=450630
http://www.linuxquestions.org/questions/linux-software-2/grub-freezes-before-uncompressing-kernel-464619/

not sure if really all of them are the edd problem i have, but i`m quite sure for some of those.
can provide more links if somebody likes.

> Adding 3 printks for each such obscure problem would make it even more 
i wouldn`t call that problem obscure.
i have seen this problem more than 5 times since that code is in linux. so it`s at least enough to discuss about even if no other person thinks it`s necessary :)  just the fact that it`s not been discussed often (here or elsewhere) doesn`t mean, that it exist or that users come across that. it`s more that type of "mhh, let`s try linux instead of windows. oh, doesn`t boot. ok, let`s stay with windows then...". you don`t expect people like those posting the right question to the right forum, do you?


> If there are known chipsets / BIOSes that have this problem - applying 
> quirks - something like this quirk for pmtmr [1]- (if they work this 
> early) or even special casing them with forced edd=off may be the right and more useful thing to do.
mhh. i`m unsure. ok, i`m no kernel-hacker but there are so many variants of bios/hardware out there so blacklisting certain bios versions may be never more than half of a solution.

roland


> -----Ursprüngliche Nachricht-----
> Von: "Parag Warudkar" <parag.warudkar@gmail.com>
> Gesendet: 16.12.07 18:34:48
> An: devzero@web.de
> CC: linux-kernel@vger.kernel.org, Matt.Domsch@dell.com, hpa@zytor.com
> Betreff: Re: [PATCH] [RFC] be more verbose when probing EDD

> 
> On Sun, 16 Dec 2007, devzero@web.de wrote:
> 
> >
> > - it seems there are buggy Bios implementations out there which have problems with EDD
> > - your favourite distro may have set CONFIG_EDD=y|m , so EDD probe is on by default quite often nowadays.
> > - setting "edd=off" when you get that hang on boot is _not_ obvious.
> 
> It does not look like this issue is common - googling for "Linux EDD Boot 
> hang" does not bring up relevant and recent results - in fact this post of 
> yours comes on top. Further more there does not seem to be problems with 
> newer BIOSes so we would be irritating lot many users needlessly.
> 
> Adding 3 printks for each such obscure problem would make it even more 
> complex to parse and make sense of the boot log - I, for example, already 
> dislike the mostly-useless-to-end-user stuff it spews on a normal boot.
> 
> If there are known chipsets / BIOSes that have this problem - applying 
> quirks - something like this quirk for pmtmr [1]- (if they work this 
> early) or even special casing them with forced edd=off may be the right and more useful thing to do.
> 
> [1] http://www.webservertalk.com/archive242-2006-3-1447442.html
> 
> Parag
> 


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 3 Monate
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

