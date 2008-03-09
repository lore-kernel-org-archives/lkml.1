Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYCIPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYCIPeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYCIPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:34:28 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:37345 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYCIPe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:34:28 -0400
Date: Sun, 9 Mar 2008 18:34:25 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Bob Tracy <rct@frus.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Message-ID: <20080309153425.GA1391@jurassic.park.msu.ru>
References: <20080308035828.E9403DBA2@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080308035828.E9403DBA2@gherkin.frus.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 09:58:28PM -0600, Bob Tracy wrote:
> (1) Using the sox-based "play" command to play a short ".wav" file
>     results in the file being played approx. 1.5 times, i.e., it plays
>     all the way through, then restarts from the beginning and quits
>     somewhere in the middle of the second playback.  At least the
>     sound doesn't seem distorted...
> 
> (2) Using "mpg123" results in silence at first, then after about 30
>     seconds, a tight loop of random repeating sound (doesn't sound like
>     part of the mp3 file, but it's probably derived from it :-)) until
>     the process is forcibly killed.

Sounds like a DMA screwup. However, I'm pretty sure that it's not a
generic ALSA problem with ISA DMA, as my good old GUS MAX still works
perfectly on lx164 (machine that is very similar to your miata) as
I checked yesterday with patched 2.6.25-rc4. :-)

> I have to hit <ctrl>C twice to interrupt playback.
> 
> /proc/asound/cards looks normal:
> 
>  0 [ES1888         ]: ES1888 - ESS AudioDrive ES1888
>                       ESS AudioDrive ES1888 at 0x220, irq 5, dma1 1, dma2 5

I wonder if it still works on x86 - perhaps you ought to ask ALSA folks.
I'll search my machine room next week - I recall that there were a dozen
of old ISA soundcards, maybe there is some es18xx stuff, but chances
are slim...

Ivan.
