Return-Path: <linux-kernel-owner+w=401wt.eu-S1755535AbYFLSbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbYFLSbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYFLSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:31:10 -0400
Received: from po-out-1718.google.com ([72.14.252.155]:49946 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYFLSbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VxWCUyFm9RvFEXisur1QEfRpTzvM4LseVlRKfeJ4MQd4WGZJRugwdgAeChN+knrYIg
         enyauaiRtlPXl/TJo0NCncChz/v3FxxiTGVjNZXueL+Th3Jll1t1rtpiHwAyW1m+Ryya
         7dnjccgm+hGDpReE/8Oin7MA6fwpYenwSBzNA=
Message-ID: <19f34abd0806121131p295abc41q2668d2c389fd500e@mail.gmail.com>
Date: Thu, 12 Jun 2008 20:31:08 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: ALC883 recording troubles...
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5h3ani1qvs.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806091259t47c9b070v269da0f5855ef014@mail.gmail.com>
	 <19f34abd0806120648j4f15b762r8e72c348c14b946f@mail.gmail.com>
	 <s5hhcbyrcak.wl%tiwai@suse.de>
	 <19f34abd0806120655u75df09bfuaf33f1d54128b0b7@mail.gmail.com>
	 <s5hej72rbsh.wl%tiwai@suse.de>
	 <19f34abd0806120718g21ddfa3bjbf6f194aa1d3d37d@mail.gmail.com>
	 <s5h8wxarauf.wl%tiwai@suse.de>
	 <19f34abd0806120955r4734bca8h44774bacc65aca37@mail.gmail.com>
	 <19f34abd0806121029j1f9cabf0nc852c6e1a0a98d4f@mail.gmail.com>
	 <s5h3ani1qvs.wl%tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 7:53 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> ..or it certainly seems that all the inputs claim to have output
>> capability too. Maybe this is what is confusing ALSA?
>
> No.
>
> Basically, the input/output amps mean the amp input to the widget
> and the amp output from the widget, respectively.  They don't mean
> that the playback or capture stream direction.  So, it's perfectly OK
> if the amp is output for a capture stream.
>
> One exception is the pin widget.  In this case, the input amp means
> the amp applied for the input signal from this pin, and the output amp
> means the amp applied before sending to this pin.  So, the
> input/output actually corresponds to the stream direction.  But, for
> other widgets, the amp I/O is just a difference between before or
> after.

Okay, yes. I now output the nid that is changing too, and you are
correct, it is not the pin widget, but this one:

Node 0x23 [Audio Selector] wcaps 0x30010d: Stereo Amp-Out
  Amp-Out caps: ofs=0x0b, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-Out vals:  [0x03 0x03]
  Connection: 7
     0x18 0x19 0x1a 0x1c 0x14 0x15 0x12*

I guess I will need to read up on what exactly an audio selector is
before attempting any more debugging.

Thank you for keeping up so far. I'll try to shut up now until I have
something more tangible to report :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
