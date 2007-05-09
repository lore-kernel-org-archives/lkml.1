Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbXEIJTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbXEIJTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXEIJS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:18:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:36801 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470AbXEIJSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:18:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GDco54SLhhu3gKjgywMVvs4VMerNSK0uw9dTgJjKjkqH6RCfCWL7O0OQdkLI1zEChCabS1llWLneCNUuLQRQjENSiFGDIQ8Zv1jNWuK5XFAhryplR1FU7k7/PXx7hn9swytBvIvEg3j5yBQwfly/qDNgD8qAKD9KxvQbCpqxtfI=
Message-ID: <8d6898730705090218h4ba10102u917b0943bad97a8b@mail.gmail.com>
Date: Wed, 9 May 2007 14:48:54 +0530
From: "Nobin Mathew" <nobin.mathew@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [ASoC] Mic record is not working with wm9713 ASoC driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to record mic with AsoC wm9713 driver. My Mic is connected "Mic 1".

My settings

'Mic A Source' -> "Mic 1"
'Mic Boost (+20dB)' [on]
'Capture' [on]
'Left Capture Source' "Mic 1"
'Right Capture Source' "Mic 1"


i am issuing following command to record
"arecord -M -f S16_LE sound.wav"

But what i found is driver is not enabling "Mic bias" and "Mic A PGA"

this dump of /sys/devices/platform/soc-audio/dapm_widget while
"arecord" is running is given below


Mic Bias: Off
Mic B Pre Amp: Off
Mic A Pre Amp: On
Mic B PGA: Off
Mic A PGA: Off
Mono In: Off
Right Line In: Off
Left Line In: Off
Mono Out: Off
Out 4: Off
Out 3: Off
Right Speaker: Off
Left Speaker: Off
Right Headphone: Off
Left Headphone: Off
Right ADC: On
Left ADC: On
Aux DAC: Off
Voice DAC: Off
Capture Mixer: Off
HP Mixer: Off
AC97 Mixer: Off
Right DAC: Off
Left DAC: Off
Speaker Mixer: Off
Mono Mixer: Off
Right HP Mixer: Off
Left HP Mixer: Off
PM State: D0

In idea why this is happening?
what is going wrong with my settings?

Nobin Mathew
