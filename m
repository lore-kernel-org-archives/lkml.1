Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYDNKlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYDNKlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 06:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYDNKk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 06:40:59 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:46783 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbYDNKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:40:59 -0400
Message-ID: <48033561.3070309@keyaccess.nl>
Date: Mon, 14 Apr 2008 12:43:45 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andreas Mueller <andreas@stapelspeicher.org>, linux-kernel@vger.kernel.org,
       MatzeBraun@gmx.de, ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] es1968: fix jitter on some maestro cards
References: <20080329234943.GA2899@slappy>	<47F164AB.5040009@keyaccess.nl> <s5habjwhh1p.wl%tiwai@suse.de>
In-Reply-To: <s5habjwhh1p.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-08 12:22, Takashi Iwai wrote:

> At Tue, 01 Apr 2008 00:24:43 +0200,
> Rene Herman wrote:
>> On 30-03-08 00:49, Andreas Mueller wrote:
>>
>>> This patch suppresses jitter on several Maestro cards in stereo mode
>>> (ALSA of course).
>>>
>>> The patch is also incorporated in the *BSD drivers where I "ported" it from.
>>> I am barely used to driver-development so please take a look (esp. the channel
>>> parameters), nevertheless it completely works for me.
>>>
>>> Without this patch most of the stereo audio gets out of sync and really
>>> distorted (oss-emulation with mplayer at 48000khz worked somehow).
>>>
>>> CCed to those listed in the .c file.
>> Added the alsa-devel list (and re-attached the patch). My TerraTec DMX (ESS 
>> Canyon3D, ES1970MS-3D) doesn't need this but doesn't seem to suffer from it 
>> either. Otherwise no idea about this.
> 
> This should depend on the sample rate you use.  48k would work without
> the patch.

Just to be clear archive-wise -- on this Canyon3D, so does 44100.

> Anyway, I applied it to ALSA tree now.  Thanks.

Rene.

