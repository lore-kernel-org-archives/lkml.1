Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYFLNz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYFLNz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759424AbYFLNzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:55:48 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:3371 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757806AbYFLNzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YNO+NfMQovbPGTwPtfTkGymqQztZPGMf+koTyWpzGOqsdcoiQMCdnUZ3WNn9WLnz2a
         IpUvTCCX3mWYhTrnRrbOxFHXTgJm729cfl3G5nY5KLxZuXyoBoGK/E0Pb4VQHFCc+a9o
         V+I/DeYm3vPRbphe/tqHltiep0x2aJ6r6MDWc=
Message-ID: <19f34abd0806120655u75df09bfuaf33f1d54128b0b7@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:55:45 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hhcbyrcak.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <s5habhtesoq.wl%tiwai@suse.de>
	 <6278d2220806111200g4f802885wfc5f0fd6c0405efb@mail.gmail.com>
	 <s5hiqwf0vyr.wl%tiwai@suse.de>
	 <19f34abd0806120603q2ddc6654r9562dfea556c2791@mail.gmail.com>
	 <s5hlk1are3o.wl%tiwai@suse.de>
	 <19f34abd0806120648j4f15b762r8e72c348c14b946f@mail.gmail.com>
	 <s5hhcbyrcak.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 3:52 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 12 Jun 2008 15:48:32 +0200,
> Vegard Nossum wrote:
>>
>> The external mic:
>>
>> Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
>>   Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
>>   Amp-In vals:  [0x00 0x00]
>
> The input volume is zero.  Try to raise "Mic Boost" (if present)?

They're already all up.

Line In Boost = 100
Mic Boost = 100
Internal Mic Boost = 100

Right after changing all these to max, I've read the value from
card0/codec#0 again:

Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x02, stepsize=0x4f, mute=0
  Amp-In vals:  [0x00 0x00]

There doesn't seem to be any difference. Even when changing them all
to 0 in alsamixer, this output stays the same.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
