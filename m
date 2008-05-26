Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYEZHQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYEZHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYEZHQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:16:21 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37332 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930AbYEZHQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:16:21 -0400
X-Sasl-enc: +SF58EiqMtvXExs/Rv+TjHfws1Jtb91rfbpO/ojZ25aR 1211786179
Message-ID: <483A63BF.1050805@ladisch.de>
Date: Mon, 26 May 2008 09:16:15 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Kallol Biswas <nucleodyne@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>, Lee Revell <rlrevell@joe-job.com>,
       linux-kernel@vger.kernel.org, Xiaogeng Jin <xiaogeng.jin@yahoo.com>
Subject: Re: HDMI Audio Support in ALSA
References: <438397970805190904i2656337dh26a3257fe52aa29d@mail.gmail.com>	 <75b66ecd0805190916r7ce21667laf19783dfa47cdd7@mail.gmail.com>	 <438397970805190938t195d9a8ejfd5b0ca1409714ab@mail.gmail.com>	 <48328771.4030804@ladisch.de>	 <438397970805211252u1d228ad8wcb1a6ef9b1251478@mail.gmail.com>	 <483568BD.4040701@ladisch.de> <s5hod6xuvq3.wl%tiwai@suse.de> <438397970805242141l3f07e6e1he5805b09d9dbf989@mail.gmail.com>
In-Reply-To: <438397970805242141l3f07e6e1he5805b09d9dbf989@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kallol Biswas wrote:
> The routine snd_hda_calc_stream_format() calls snd_pcm_format_width()
> to find if the format is supported and the width.
>
> The array holds pcm_format[] holds all the supported formats. However,
> in this array
> there is no entry for IEC 60958 or IEC 61937.

There is.  I already told you that these formats use
SNDRV_PCM_FORMAT_S16_LE.


Regards,
Clemens
