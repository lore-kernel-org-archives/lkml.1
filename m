Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbYCJPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbYCJPIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbYCJPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:08:13 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:60483 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYCJPIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:08:12 -0400
Message-ID: <47D54EF9.1080901@keyaccess.nl>
Date: Mon, 10 Mar 2008 16:08:41 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org, ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080308035828.E9403DBA2@gherkin.frus.com> <20080309153425.GA1391@jurassic.park.msu.ru>
In-Reply-To: <20080309153425.GA1391@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-03-08 16:34, Ivan Kokshaysky wrote:

> On Fri, Mar 07, 2008 at 09:58:28PM -0600, Bob Tracy wrote:
>> (1) Using the sox-based "play" command to play a short ".wav" file
>>     results in the file being played approx. 1.5 times, i.e., it plays
>>     all the way through, then restarts from the beginning and quits
>>     somewhere in the middle of the second playback.  At least the
>>     sound doesn't seem distorted...
>>
>> (2) Using "mpg123" results in silence at first, then after about 30
>>     seconds, a tight loop of random repeating sound (doesn't sound like
>>     part of the mp3 file, but it's probably derived from it :-)) until
>>     the process is forcibly killed.
> 
> Sounds like a DMA screwup. However, I'm pretty sure that it's not a
> generic ALSA problem with ISA DMA, as my good old GUS MAX still works
> perfectly on lx164 (machine that is very similar to your miata) as
> I checked yesterday with patched 2.6.25-rc4. :-)
> 
>> I have to hit <ctrl>C twice to interrupt playback.
>>
>> /proc/asound/cards looks normal:
>>
>>  0 [ES1888         ]: ES1888 - ESS AudioDrive ES1888
>>                       ESS AudioDrive ES1888 at 0x220, irq 5, dma1 1, dma2 5
> 
> I wonder if it still works on x86 - perhaps you ought to ask ALSA folks.
> I'll search my machine room next week - I recall that there were a dozen
> of old ISA soundcards, maybe there is some es18xx stuff, but chances
> are slim...

Missed the original mssage, adding alsa-devel. I have a few dozen es18xx's 
cards but no Alpha's. Am compiling a 2.6.25-rc4 onto an x86 test box now.

Rene.
