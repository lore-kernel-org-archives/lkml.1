Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbXHBG1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbXHBG1K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 02:27:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXHBG0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 02:26:55 -0400
Received: from [202.78.101.198] ([202.78.101.198]:37006 "EHLO mx1.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751883AbXHBG0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 02:26:54 -0400
Message-ID: <46B17937.1050401@gmail.com>
Date: Thu, 02 Aug 2007 14:27:03 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: =?UTF-8?B?TGVuYXIgTMO1aG11cw==?= <lenar@city.ee>
Cc: Klaus Schulz <Klaus.Schulz@web.de>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: ck vs. cfs : realtime audio performance
References: <1185870355.7933.55.camel@klaus-laptop> <1185886161.7397.11.camel@klaus-laptop> <46AF3111.7090206@city.ee>
In-Reply-To: <46AF3111.7090206@city.ee>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lenar Lõhmus wrote:
> Klaus Schulz wrote:
>>> I am currently testing the 2.6.22.1 cfs-rt9 vs. ck1 on my rather pure
>>> realtime high-end-audio setup. (NO X, just a terminal, streaming 
>>> .wav. I am using my own written player and brutefir as the audio 
>>> engine.)
>>> Comment: This is not a standard (amarok or xmms setup), all buffers in
>>> the chain are very small. Any problem will immidetialy end up in xruns.
>>> The sounddriver, HW (pci-bus etc.) are tweaked accordingly
>>> Until now ck1 on 2.6.22 is giving me better results (less audible
>>> distortions) and runs extremely stable compared to cfs. Under ck I 
>>> ran my player with schedtool -R -p 98, which was better than
>>> running it e.g. with nice -20 Both setups under cfs were giving me 
>>> worse results than ck.
>>> With CFS I also experienced XRUNS from time to time, what never happened
>>> with ck.

See, this is exactly the problem of the SD ranters.  A ranter posts a 
problem, doesn't give reproducability hints, and neither provides technical 
detail, not even the slightest relevant stats.  And the most irritating 
part is that the code that the OP wrote (or at least its relevant parts) is 
not even available for download.

I was wondering why the OP need timers for audio playback.  What type of 
audio?  PCM, MIDI?  Once does not need timers for PCM playback but for MIDI.

SD ranters. Pure rants.

Thank you very much.

Best Regards,

Carlo


-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, UP Campus Diliman
1101 Quezon City, Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp


-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, UP Campus Diliman
1101 Quezon City, Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
