Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbZCTS4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbZCTS4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbZCTS4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:56:44 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:41953 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbZCTS4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:56:43 -0400
Date: Fri, 20 Mar 2009 19:56:40 +0100
From: Andreas Mohr <andi@lisas.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andreas Mohr <andi@lisas.de>, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [alsa-devel] Bugs on aspire one A150
Message-ID: <20090320185640.GA17278@rhlx01.hs-esslingen.de>
References: <20090316212227.GA29471@rhlx01.hs-esslingen.de> <s5hfxhczinh.wl%tiwai@suse.de> <20090317100500.GA16029@rhlx01.hs-esslingen.de> <20090317103845.GA26007@rhlx01.hs-esslingen.de> <20090317104755.GA1446@rhlx01.hs-esslingen.de> <s5h3adcpf1i.wl%tiwai@suse.de> <20090317161828.GA32756@rhlx01.hs-esslingen.de> <s5h3adbhovj.wl%tiwai@suse.de> <20090318090507.GA30453@rhlx01.hs-esslingen.de> <s5hsklbchmu.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hsklbchmu.wl%tiwai@suse.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 18, 2009 at 10:19:53AM +0100, Takashi Iwai wrote:
> At Wed, 18 Mar 2009 10:05:07 +0100,
> Andreas Mohr wrote:
> > 
> > Hi,
> > 
> > On Tue, Mar 17, 2009 at 09:32:16PM +0100, Takashi Iwai wrote:
> > > Don't use -Dplughw:0.  Then the default setup will be used.
> > > 
> > > 	% arecord -fdat -c1 test.wav
> > 
> > Tried that, didn't help. /usr/share/alsa/cards/HDA-Intel.conf still
> > contains the patch, but equal Capture Volume sliders still silenced
> > audio input, whereas non-equal worked. Hmm.
> 
> What is the output with -v option?

Sorry for the delay!

$ arecord -fdat -c1 -v test.wav; aplay test.wav 
Recording WAVE 'test.wav' : Signed 16 bit Little Endian, Rate 48000 Hz, Mono
ALSA <-> PulseAudio PCM I/O Plugin
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 1
  rate         : 48000
  exact rate   : 48000 (48000/1)
  msbits       : 16
  buffer_size  : 24000
  period_size  : 6000
  period_time  : 125000
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 6000
  period_event : 0
  start_threshold  : 1
  stop_threshold   : 24000
  silence_threshold: 0
  silence_size : 0
  boundary     : 1572864000
^CAborted by signal Interrupt...
Playing WAVE 'test.wav' : Signed 16 bit Little Endian, Rate 48000 Hz, Mono
andi@andinet:/tmp$ 


Hmm. Note the pulseaudio stuff above...


I did verify that this test run using -v did exhibit failure again.

Thanks,

Andreas
