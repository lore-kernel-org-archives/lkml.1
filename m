Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbYCJT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbYCJT3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbYCJT3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 15:29:11 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:43681 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYCJT3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 15:29:10 -0400
Message-ID: <47D58C1F.7020805@keyaccess.nl>
Date: Mon, 10 Mar 2008 20:29:35 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Bob Tracy <rct@frus.com>, ALSA devel <alsa-devel@alsa-project.org>,
       Michael Cree <mcree@orcon.net.nz>, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
References: <20080310162130.AFFD3DBA2@gherkin.frus.com>	<47D56851.2000509@keyaccess.nl> <s5h3aqywlf0.wl%tiwai@suse.de>
In-Reply-To: <s5h3aqywlf0.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-03-08 18:14, Takashi Iwai wrote:

>> Takashi? Wasn't there an OSS emulation on Alpha thing a while ago?
> 
> No, I don't know of.  OSS emulation code is written fairly independently
> from architectures.  Maybe just a missing CONFIG_SND_PCM_PLUGINS kconfig?

Could've sworn...

The bug seems not present on x86. I'm testing with a ES1968 and ES1898 (his 
is a 18888) and playback through ALSA native nor OSS emulation is giving me 
trouble up to now.

Bob? How short are "short" wav files by the way?

Rene.


