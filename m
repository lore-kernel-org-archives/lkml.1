Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXFYLgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXFYLgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 07:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXFYLg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 07:36:26 -0400
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:21125 "EHLO
	rudy.mif.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXFYLgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 07:36:25 -0400
Date: Mon, 25 Jun 2007 13:36:23 +0200 (CEST)
From: =?ISO-8859-2?Q?Tomasz_K=B3oczko?= <kloczek@rudy.mif.pg.gda.pl>
To: Takashi Iwai <tiwai@suse.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
In-Reply-To: <s5h3b0gi9mp.wl%tiwai@suse.de>
Message-ID: <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl>
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>
 <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>
 <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl>
 <s5h3b0gi9mp.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="0-1132527078-1182771383=:25800"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1132527078-1182771383=:25800
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 25 Jun 2007, Takashi Iwai wrote:
[..]
>> Sound it in not rocket science. In 99.9% cases you need well abstracted
>> API which ALSA doe not provide and this is real cause why so poor sound
>> support in Linux applications is. Thin ALSA abstraction is main cause of
>> avalaibability "tons" of additional soud user space APIs.
>
> I disagree about this.  Tons of various user-space APIs would be
> created anyway.  It's the nature of FOSS developemnt.

Please recall history of (for example) esound.
>From esound README:

"Esound is an audio mixing server that allows multiple
applications to output sound to the same audio device."

It was started in time when most cheap sound cards was without hw mixer.
And .. when today you use ALSA on sound card without hw mixer still all 
this (past ?) problems are actual.
Look on main reasons developing arts ..
In documentation many other user space APIs you can find the same 
or similar reasons. Look .. I'm talkimg about real facts. Your 
disagreement completly ommits *reasons* spending some time on preapare 
this soud APIs.

ALSA still does not provides good soud devices virtualization for more 
then one application. Each day I'm using bludy words when I'm try to use 
skype which oppens /dev/mixer after run galeon with flash plugin which 
opens /dev/snd/pcm* or when I start GNOME session with soud enabled 
(handled by esd whuich uses ALSA).

kloczek
-- 
-----------------------------------------------------------
*Ludzie nie maj± problemów, tylko sobie sami je stwarzaj±*
-----------------------------------------------------------
Tomasz K³oczko, sys adm @zie.pg.gda.pl|*e-mail: kloczek@rudy.mif.pg.gda.pl*
--0-1132527078-1182771383=:25800--
