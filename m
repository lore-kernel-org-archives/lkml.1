Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbYJVSdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbYJVSdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbYJVSdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:33:38 -0400
Received: from node03.cambriumhosting.nl ([217.19.16.164]:56255 "EHLO
	node03.cambriumhosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522AbYJVSdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:33:37 -0400
X-Greylist: delayed 1842 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2008 14:33:37 EDT
Message-ID: <48FF6AC8.6020103@powercraft.nl>
Date: Wed, 22 Oct 2008 20:02:48 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080724 Thunderbird/2.0.0.16 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       em28xx@mcentral.de
Subject: Re: [Em28xx] [PATCH] em28xx patches against the latest git tree
References: <d9def9db0810221034v3bf4dabt6aa905b8a3ebd5a@mail.gmail.com> <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
In-Reply-To: <d9def9db0810221038g156871e1u200abb90b774ad28@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Rechberger wrote:
> On Wed, Oct 22, 2008 at 7:34 PM, Markus Rechberger
> <mrechberger@gmail.com> wrote:
>> Following patch adds the latest em28xx driver from mcentral.de.
>>
>> merging mcentral.de/hg/~mrec/em28xx-new with upstream kernel
>>
>> * adding VBI support to most VBI capable devices
>> * radio support for cx25843 based devices
>> * extra cx25843 driver (registers match the em28xx configuration in
>> order to support proper VBI)
>> * all videostandards and inputs are tested with cx25843 based devices
>> * adding alternative audio driver for em28xx devices (independent
>> audio transfer, not depending on oss/alsa)
>> * adding em28xx-webcam support for videology webcams
>> * adding em28xx-audioep audio driver for alternate number 1 - if
>> vendor specific and not USB audio conform
>> * adding s921 driver (ISDB-T 1Seg support tunneling parameters through
>> DVB-T API setting specific registers to auto)
>> * adding xc3028 mostly original sourcecode from the manufacturer (most
>> recent version), merged xc3028/xc3028l into
>>  one external firmware blob - important for signal quality
>> * adding xc5000 mostly original sourcecode from the manufacturer (most
>> recent version) - important for signal quality
>> * adding lgdt3304, although currently disabled
>> * remote control handling *works* but is broken by design and disabled
>> since different rc5/rc6/nec remotes return
>>  different values. Handling can be done using interrupt transfers too (TODO)
>> * fixed a couple of bugs in the em28xx-audio driver which can lead to
>> system hangs.
>>
>> ----
>>
>> as for testing:
>> * analog TV: patched tvtime (for analog TV) version available on
>> mcentral.de which supports 1. software rendering 2. digital
>> audio/alsa/aad
>> * FM radio: gqradio from mcentral.de, there's also an older radio
>> patch for vlc available.
>> * DVB-T: all applications should work with it
>> * ISDB-T: relevant for China and Brazil only, can be used with
>> dvbtune, dvbscan (the channel file cannot be used due problems with
>> the characters), for transferring the MPEG-TS stream dvbstream,
>> dvbsnoop, for playback gstreamer/mplayer (h264/aac isn't supported
>> well with it).
>>
>> commit history is available at:
>> http://mcentral.de/http://git.kernel.org/?p=linux/kernel/git/mrec/linux-2.6.git;a=commit;h=f1be9ae8f8489a6598417a194e0899ac00c7530ehg/~mrec/em28xx-new
>>
> 
> this should be:
> http://mcentral.de/hg/~mrec/em28xx-new/shortlog
> 
>> This patch adds a separate instance of the driver to the git
>> repository, not affecting anything existing.
>>
>> the full patch against the git repository:
>>
>>
>> Contributors:
>> user:        acano@fastmail.fm
>> user:        Andre Kelmanson <akelmanson@gmail.com>
>> user:        Bouwsma Barry <freebeer.bouwsma@gmail.com>
>> user:        Dan Kreiser <kreiser@informatik.hu-berlin.de>
>> user:        Frank Neuber <fn@kernelport.de>
>> user:        Jelle de Jong <jelledejong@powercraft.nl>
>> user:        John Stowers <john.stowers.lists@gmail.com>
>> user:        Lukas Kuna <lukas.kuna@evkanet.net>
>> user:        Stefan Vonolfen <stefan.vonolfen@gmail.com>
>> user:        Stephan Berberig <s.berberig@arcor.de>
>> user:        Thomas Giesecke <thomas.giesecke@ibgmbh-naumburg.de>
>> user:        Vitaly Wool <vwool@ru.mvista.com>
>> user:        Zhenyu Wang <zhen78@gmail.com>
>>
>> Signed-off-by: Markus Rechberger <mrechberger@sundtek.de>
>>
> 

Thumbs up for the git merge process, keep up the good work!

Kind regards,

Jelle
