Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXEIKWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXEIKWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbXEIKVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:21:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756644AbXEIKVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:21:43 -0400
Date: Wed, 9 May 2007 03:21:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nobin Mathew" <nobin.mathew@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>
Subject: Re: [ASoC] Mic record is not working with wm9713 ASoC driver
Message-Id: <20070509032105.aebb8310.akpm@linux-foundation.org>
In-Reply-To: <8d6898730705090218h4ba10102u917b0943bad97a8b@mail.gmail.com>
References: <8d6898730705090218h4ba10102u917b0943bad97a8b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2007 14:48:54 +0530 "Nobin Mathew" <nobin.mathew@gmail.com> wrote:

> I am trying to record mic with AsoC wm9713 driver. My Mic is connected "Mic 1".
> 
> My settings
> 
> 'Mic A Source' -> "Mic 1"
> 'Mic Boost (+20dB)' [on]
> 'Capture' [on]
> 'Left Capture Source' "Mic 1"
> 'Right Capture Source' "Mic 1"
> 
> 
> i am issuing following command to record
> "arecord -M -f S16_LE sound.wav"
> 
> But what i found is driver is not enabling "Mic bias" and "Mic A PGA"
> 
> this dump of /sys/devices/platform/soc-audio/dapm_widget while
> "arecord" is running is given below
> 
> 
> Mic Bias: Off
> Mic B Pre Amp: Off
> Mic A Pre Amp: On
> Mic B PGA: Off
> Mic A PGA: Off
> Mono In: Off
> Right Line In: Off
> Left Line In: Off
> Mono Out: Off
> Out 4: Off
> Out 3: Off
> Right Speaker: Off
> Left Speaker: Off
> Right Headphone: Off
> Left Headphone: Off
> Right ADC: On
> Left ADC: On
> Aux DAC: Off
> Voice DAC: Off
> Capture Mixer: Off
> HP Mixer: Off
> AC97 Mixer: Off
> Right DAC: Off
> Left DAC: Off
> Speaker Mixer: Off
> Mono Mixer: Off
> Right HP Mixer: Off
> Left HP Mixer: Off
> PM State: D0
> 
> In idea why this is happening?
> what is going wrong with my settings?
> 

(maintainers cc'ed)
