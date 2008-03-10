Return-Path: <linux-kernel-owner+w=401wt.eu-S1753892AbYCJPVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892AbYCJPVX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYCJPVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:21:09 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:57938 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYCJPVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:21:07 -0400
Message-ID: <47D55201.5050301@keyaccess.nl>
Date: Mon, 10 Mar 2008 16:21:37 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: Bob Tracy <rct@frus.com>, Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080309235800.17D26DBA2@gherkin.frus.com> <47D4E480.3090309@orcon.net.nz> <47D55115.3010708@keyaccess.nl>
In-Reply-To: <47D55115.3010708@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-03-08 16:17, Rene Herman wrote:

> On 10-03-08 08:34, Michael Cree wrote:
> 
>> Bob Tracy wrote:
> 
>>> Supposedly with the ES1888, dma1 is for capture, dma2 is for 
>>> playback. dma2 == 5 is a 16-bit channel, yes?  That could explain 
>>> much...
> 
> It is, but what would it explain? You're only having playback problems, 
> right?
> 
>>>
>>> As for the values "chosen" for dma1 and dma2, they are the ones that
>>>  keep showing up in the Alpha sound "howto" postings/documents.
>>
>> Running 'show config' in SRM on my Alphas (PWS500au and XP1000) reveals
>> the settings (except possibly for mpu_port) for the ESS1888 sound chip.
>> I recall that they are as reported in Alpha sound howtos.
> 
> Can it be forced to use dma2=0 (an 8-bit channel, and the usual capture 
> channel on es18xx)? However, that might not be the issue anyway:
> 
>> I hadn't been using the ESS1888 for awhile, but have just tried it out
>> since you reported problems.  I am running kernel 2.6.24.3 and Debian
>> testing on the XP1000.  I tried playing a number of wav files with
>> alsa's aplay, sox's play and with mocp.  I found that aplay and mocp
>> worked reliably through the ESS1888.  Sox's play on some files did play
>> back a small extra segment of the file - particularly on short files and
>> usually some section near the end of the file - once it had completed
>> playing the file once; maybe this is what you are also observing. 
> 
> This sounds very suspiciously like a difference with playing through the 
> native ALSA interface and the OSS emulaion. Could you and/or Bob confirm 
> that sox is using the OSS emulation and not ALSA natively?

Bob is spam-blocking me (sigh...) so perhaps you can make sure he sees this.

> I could very well imagine the ALSA OSS emulation being broken on Alpha. 
> I doubt any of teh developers has an Alpha. And if aplay works correctly 
> this seems very likely.
> 
> "sox" _can_ use ALSA natively as well by the way (see manpage for the 
> version you have installed).
> 
>> More onerously, my testing eventually ended in a complete system lock up!
>> I ran play (or was it aplay - sorry can't remember now)
> 
> Vital if play is using the OSS interface...
> 
>> and the system locked up. Got a response with ping across the network but
>> couldn't log in via ssh.  Have been playing mplayer through the ESS1888
>> for the last couple of days (don't like it though - the sound quality of
>> the ESS1888 is not good enough for my ears) and haven't had another one
>> of those lockups since.
> 
> Mmm.

Rene
