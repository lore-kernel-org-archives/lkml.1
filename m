Return-Path: <linux-kernel-owner+w=401wt.eu-S1752149AbYCJItK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbYCJItK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 04:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbYCJIs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 04:48:58 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:53562 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbYCJIs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 04:48:57 -0400
X-Greylist: delayed 4466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Mar 2008 04:48:57 EDT
Message-ID: <47D4E480.3090309@orcon.net.nz>
Date: Mon, 10 Mar 2008 20:34:24 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: Bob Tracy <rct@frus.com>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080309235800.17D26DBA2@gherkin.frus.com>
In-Reply-To: <20080309235800.17D26DBA2@gherkin.frus.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 10 Mar 2008 20:34:24 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Mar 10 20:34:27 2008
X-DSPAM-Confidence: 0.7781
X-DSPAM-Improbability: 1 in 352 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy wrote:
> Supposedly with the ES1888, dma1 is for capture, dma2 is for 
> playback. dma2 == 5 is a 16-bit channel, yes?  That could explain 
> much...
> 
> As for the values "chosen" for dma1 and dma2, they are the ones that
>  keep showing up in the Alpha sound "howto" postings/documents.

Running 'show config' in SRM on my Alphas (PWS500au and XP1000) reveals
the settings (except possibly for mpu_port) for the ESS1888 sound chip.
I recall that they are as reported in Alpha sound howtos.

I hadn't been using the ESS1888 for awhile, but have just tried it out
since you reported problems.  I am running kernel 2.6.24.3 and Debian
testing on the XP1000.  I tried playing a number of wav files with
alsa's aplay, sox's play and with mocp.  I found that aplay and mocp
worked reliably through the ESS1888.  Sox's play on some files did play
back a small extra segment of the file - particularly on short files and
usually some section near the end of the file - once it had completed
playing the file once; maybe this is what you are also observing.   More
onerously, my testing eventually ended in a complete system lock up!
I ran play (or was it aplay - sorry can't remember now) and the system
locked up. Got a response with ping across the network but couldn't log
in via ssh.  Have been playing mplayer through the ESS1888 for the last
couple of days (don't like it though - the sound quality of the ESS1888
is not good enough for my ears) and haven't had another one of those
lockups since.

Cheerz
Michael.
