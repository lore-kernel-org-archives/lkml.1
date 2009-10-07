Return-Path: <linux-kernel-owner+w=401wt.eu-S1759338AbZJGO2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759338AbZJGO2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbZJGO2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:28:49 -0400
Received: from mail-qy0-f202.google.com ([209.85.221.202]:46810 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759267AbZJGO2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=tNsIN8WY07l1ERDwgnLaWHGxrE3Ky9eekj2I1U0kvM7IgLJhu0YRutW9tS75DIjcvk
         0VglhvJvrdnUA9H0t+bsS4NRdMHvgr1APPNxFcy74B4mTOxrkL8RPjriP8l2KzUuT6dQ
         ZlDHni6Q07iHRELGqCMaSfp65fD0WDt+RCO0s=
MIME-Version: 1.0
In-Reply-To: <20091007120643.GA17069@rakim.wolfsonmicro.main>
References: <20091006074635.GA2775@ucw.cz> <1254829732.3546.35.camel@utx.utx.cz> 
	<20091007085806.GB28807@elf.ucw.cz> <1254914991.4213.80.camel@hammer.suse.cz> 
	<20091007120643.GA17069@rakim.wolfsonmicro.main>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 7 Oct 2009 22:27:52 +0800
Message-ID: <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com>
Subject: Re: spitz: add gpio button support (AK_INT and remote control 
	description)
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stanislav Brabec <utx@penguin.cz>, Pavel Machek <pavel@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So what's the conclusion of the patch? Any ACK/NAK or patch needs updating?

On Wed, Oct 7, 2009 at 8:06 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Oct 07, 2009 at 01:29:51PM +0200, Stanislav Brabec wrote:
>
>> SW_REMOTE_INSERT should be recognized by the Jack abstraction layer
>> (sound/core/jack.c).
>
> It's the other way around - the jack layer reports jacks for ALSA cards.
> Also, for spitz you'd probably want to be using the ASoC wrapper layer.
>
>> Well, I am thinking about defining extra values for resistors, that can
>> make stuff even more useful at cost of need of non-standard wiring on
>> fourth ring of the audio jack. It can generate SW_MICROPHONE_INSERT,
>> SW_LINEOUT_INSERT, and not yet defined SW_HEADESET_INSERT and
>> SW_LINEIN_INSERT (which would require hardware mod inside Zaurus for
>> stereo line-in).
>
> Headset should be represented by reporting headphone plus microphone on
> one jack simultaneously.
>
