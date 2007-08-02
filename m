Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbXHBH5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbXHBH5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 03:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbXHBH5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 03:57:34 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:35079 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbXHBH5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 03:57:34 -0400
Date: Thu, 02 Aug 2007 09:57:31 +0200
Message-Id: <1745683987@web.de>
MIME-Version: 1.0
From: Klaus Schulz <klaus.schulz@web.de>
To: =?iso-8859-15?Q?Lenar_L=F5hmus?= <lenar@city.ee>,
       Carlo Florendo <subscribermail@gmail.com>
Cc: Klaus Schulz <Klaus.Schulz@web.de>, ck@vds.kolivas.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: ck vs. cfs : realtime audio performance
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19M8D/eguY6Em0T087l9dX9ttIsm7BPTbFxDTXvG4QWMyDsA
 YFax1tsre+vihhWFz5+1n3VdnfcND5a+8LCqe9rJ51QMZzN75TS05fj8/8rm
 w==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Carlo.

The ranters! comment:

I can understand your way of looking at things.
But you'd better be a bit more careful with statements like these below, 
if you don't really know what's going on.

Just FYI: All possible traces - Ingo asked for - are on Ingos desk!

My intention is to support you folks as good as I can to get the issues solved.

As a user, with a rather limited knowledge about ck or cfs, I am just able to 
judge on the results these patches are delivering. 
I'll go always for the one  - if I have a choice - matching my requirements! 

Since there is just one patch left in the near future, at least the way it looks to me today, 
I am trying of course to support Ingo the best I can to identify potential issues.

Constructive critism - always welcome! 

Best regards
\Klaus


> -----Ursprüngliche Nachricht-----
> Von: Carlo Florendo <subscribermail@gmail.com>
> Gesendet: 02.08.07 08:27:01
> An: Lenar Lõhmus <lenar@city.ee>
> CC: Klaus Schulz <Klaus.Schulz@web.de>, ck@vds.kolivas.org, linux-kernel@vger.kernel.org, mingo@elte.hu
> Betreff: Re: ck vs. cfs : realtime audio performance


> 
> Lenar Lõhmus wrote:
> > Klaus Schulz wrote:
> >>> I am currently testing the 2.6.22.1 cfs-rt9 vs. ck1 on my rather pure
> >>> realtime high-end-audio setup. (NO X, just a terminal, streaming 
> >>> .wav. I am using my own written player and brutefir as the audio 
> >>> engine.)
> >>> Comment: This is not a standard (amarok or xmms setup), all buffers in
> >>> the chain are very small. Any problem will immidetialy end up in xruns.
> >>> The sounddriver, HW (pci-bus etc.) are tweaked accordingly
> >>> Until now ck1 on 2.6.22 is giving me better results (less audible
> >>> distortions) and runs extremely stable compared to cfs. Under ck I 
> >>> ran my player with schedtool -R -p 98, which was better than
> >>> running it e.g. with nice -20 Both setups under cfs were giving me 
> >>> worse results than ck.
> >>> With CFS I also experienced XRUNS from time to time, what never happened
> >>> with ck.
> 
> See, this is exactly the problem of the SD ranters.  A ranter posts a 
> problem, doesn't give reproducability hints, and neither provides technical 
> detail, not even the slightest relevant stats.  And the most irritating 
> part is that the code that the OP wrote (or at least its relevant parts) is 
> not even available for download.
> 
> I was wondering why the OP need timers for audio playback.  What type of 
> audio?  PCM, MIDI?  Once does not need timers for PCM playback but for MIDI.
> 
> SD ranters. Pure rants.
> 
> Thank you very much.
> 
> Best Regards,
> 
> Carlo
> 
> 
> -- 
> Carlo Florendo
> Softare Engineer/Network Co-Administrator
> Astra Philippines Inc.
> UP-Ayala Technopark, UP Campus Diliman
> 1101 Quezon City, Philippines
> http://www.astra.ph
> 
> --
> The Astra Group of Companies
> 5-3-11 Sekido, Tama City
> Tokyo 206-0011, Japan
> http://www.astra.co.jp
> 
> 
> -- 
> Carlo Florendo
> Softare Engineer/Network Co-Administrator
> Astra Philippines Inc.
> UP-Ayala Technopark, UP Campus Diliman
> 1101 Quezon City, Philippines
> http://www.astra.ph
> 
> --
> The Astra Group of Companies
> 5-3-11 Sekido, Tama City
> Tokyo 206-0011, Japan
> http://www.astra.co.jp
> 


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 3 Monate
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

