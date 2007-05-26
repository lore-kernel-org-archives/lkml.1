Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbXEZKm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbXEZKm2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 06:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbXEZKmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 06:42:20 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:34278 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbXEZKmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 06:42:19 -0400
Date: Sat, 26 May 2007 12:39:43 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Takashi Iwai <tiwai@suse.de>, Uwe Bugla <uwe.bugla@gmx.de>,
       linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>
Subject: Re: BUG in 2.6.22-rc2-mm1: Parts of Alsa sound architecture broken
In-Reply-To: <20070525102806.77ee9c0c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.61.0705260947130.7344@yvahk01.tjqt.qr>
References: <20070524200052.234330@gmx.net> <20070524130921.8dbd3777.akpm@linux-foundation.org>
 <s5hiragopsx.wl%tiwai@suse.de> <20070525102806.77ee9c0c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 25 2007 10:28, Andrew Morton wrote:
>> 
>> > snd: Unknown symbol unregister_sound_special
>> > snd: Unknown symbol register_sound_special_device
>> > snd: Unknown symbol sound_class
>> 
>> Uwe, could you try to revert this patch?
>> use-menuconfig-objects-ii-sound.patch
>
>I think that patch has rotted.  Too many underlying changes and the
>handling of HAS_IOMEM (at least) appears to have been broken (by my
>fixups).
>
>I'll drop it.
>
>If/when Jan resends it, pleeeeeeeeeze consider it promptly and don't leave
>me trying to maintain the thing while you guys are madly changing other
>stuff underneath it?


Here they are...



	Jan
-- 
