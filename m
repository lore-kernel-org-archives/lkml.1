Return-Path: <linux-kernel-owner+w=401wt.eu-S1765105AbXF1UGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765105AbXF1UGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760720AbXF1UGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:06:14 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:49053 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581AbXF1UGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:06:13 -0400
Message-ID: <468413D2.60101@gmail.com>
Date: Thu, 28 Jun 2007 22:02:26 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: Adrian Bunk <bunk@stusta.de>, Olivier Galibert <galibert@pobox.com>,
       Takashi Iwai <tiwai@suse.de>,
       Tomasz K?oczko <kloczek@rudy.mif.pg.gda.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>	<20070624200837.16e11305@the-village.bc.nu>	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>	<20070624215724.025a5de5@the-village.bc.nu>	<Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>	<s5h3b0gi9mp.wl%tiwai@suse.de>	<Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>	<s5hzm2ogqr7.wl%tiwai@suse.de>	<20070625124442.GA44019@dspnet.fr.eu.org>	<20070625132107.GD1094@stusta.de> <87tzssextf.fsf@hades.wkstn.nix>
In-Reply-To: <87tzssextf.fsf@hades.wkstn.nix>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2007 08:30 PM, Nix wrote:

> On 25 Jun 2007, Adrian Bunk stated:
>> If people often run into this problem it might make sense to deprecate 
>> the in-kernel OSS emulation and point people to the userspace emulation 
>> instead?
> 
> So now people need to know internal implementation details like if a
> program uses ALSA or OSS interfaces before they know how to *run* it?

Point, but one that does hinge on whether or not you feel you can call using 
the ALSA or OSS interface an implementation detail.

ALSA has been the Linux soundsystem for a number of years now and as such, 
an application that runs under Linux and produces sound more and more can be 
expected to do so using the Linux API. The only reason it _can_ be seen as a 
detail is due to the Just Works nature of the OSS emulation but that is 
changing due to the software mixing. Binary apps are also moving to ALSA 
currently, ie, flash, skype, ...

Anyways, I suspect at least Takashi Iwai would simply say "no" to removing 
or deprecating the in kernel emulation anyway, although it's not likely to 
grow features anymore.

Rene.

