Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYFTTwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYFTTwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 15:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbYFTTwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 15:52:24 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:34486 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFTTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 15:52:23 -0400
Message-ID: <485C0A97.7020909@keyaccess.nl>
Date: Fri, 20 Jun 2008 21:52:55 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       ALSA devel <alsa-devel@alsa-project.org>, mulix@mulix.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] looping S/PDIF data
References: <20080531112606.5884a1c9@mjolnir.drzeus.cx>	<20080617215504.3203a5ed@mjolnir.drzeus.cx>	<4858B84B.4030800@keyaccess.nl>	<s5hej6t91u1.wl%tiwai@suse.de>	<Pine.LNX.4.61.0806191435270.1798@tm8103-a.perex-int.cz>	<s5hskv97fqk.wl%tiwai@suse.de> <20080620214516.28e9d3f3@mjolnir.drzeus.cx>
In-Reply-To: <20080620214516.28e9d3f3@mjolnir.drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20-06-08 21:45, Pierre Ossman wrote:

> On Thu, 19 Jun 2008 14:48:19 +0200
> Takashi Iwai <tiwai@suse.de> wrote:
> 
>> At Thu, 19 Jun 2008 14:39:05 +0200 (CEST),
>> Jaroslav Kysela wrote:
>>> I don't think that this patch is correct. DMA transfers should be disabled 
>>> by:
>>>
>>> outl(what, TRID_REG(trident, T4D_STOP_B));
>>> outl(val, TRID_REG(trident, T4D_AINTEN_B));
>> They are already in the trigger callback as long as I saw the code
>> quickly.  So the problem should be somewhere else.
>>
>>> lines. Adding &= ~SPDIF_EN can disable output from AC97 to S/PDIF as well.
>> That's true.
>>
>> Anyway, if you are up now, I'll let you hunt further as you are the
>> author of the driver :)
>>
> 
> Are there any specs on this hardware? I could play around a bit myself,
> but I can't really find any documentation on the registers.

At:

ftp://ftp.alsa-project.org/pub/manuals/trident/

there's a 4D-Wave DX technical reference manual and .doc files which at 
first glance look useful.

Rene.
