Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbYCKFhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbYCKFhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 01:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYCKFg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 01:36:57 -0400
Received: from gherkin.frus.com ([192.158.254.49]:52527 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbYCKFg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 01:36:56 -0400
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D56851.2000509@keyaccess.nl> "from Rene Herman at Mar 10, 2008
 05:56:49 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Tue, 11 Mar 2008 00:36:50 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, Michael Cree <mcree@orcon.net.nz>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       ALSA devel <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.de>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080311053650.C6BF8DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> You seem to have sox installed, so try
> 
> $ sox foo.wav -t alsa default

Playback results in infinite loop over the first quarter second or so
of audio.  Using "aplay" results in same looping behavior over a longer
segment of audio -- maybe a half second.

> and
> 
> $ sox foo.wav -t ossdsp /dev/dsp

Identical results to using "play" (as expected): for the 50K ".wav"
file, I hear the entire file approx. 1.8 times.

I tried a few rmmod/insmod cycles with different values for dma2.
Results as follows:

(a) dma2=1 (== dma1): no change
(b) dma2 option omitted : no change
(c) dma2=-1 : probe failed

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
