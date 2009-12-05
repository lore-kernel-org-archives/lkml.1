Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZLEP1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZLEP1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 10:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755700AbZLEP1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 10:27:30 -0500
Received: from mailout03.t-online.de ([194.25.134.81]:57173 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbZLEP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 10:27:30 -0500
Message-ID: <4B1A7BE1.7080100@t-online.de>
Date: Sat, 05 Dec 2009 16:27:29 +0100
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091202 Thunderbird/3.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.32, hda_codec: kernel gets stuck for 3 minutes at boot time
References: <4B193FDF.3060404@t-online.de> <s5hbpidwzdo.wl%tiwai@suse.de>
In-Reply-To: <s5hbpidwzdo.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Z6x8DwZA8hkaU-yi-6j+JrvdeYPeqZTBtyMXC5qf2e0um3rUjfnttBNJ2V2Gb3PQEQ
X-TOI-MSGID: 6cf7324c-61e9-438b-b037-82425cab7889
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/09 10:20, Takashi Iwai wrote:
>
> 3 minutes is definitely too long.
> Could you double-check whether it's a hd-audio stuff, e.g. by simply
> removing snd-hda-intel module?
>

Seems that this was a problem with udev (http://bugs.debian.org/559264).
As you suspected the line about hda_codec was just the last message
before the problem came up. With the new udev package the problem is
gone.


Many thanx anyway

Harri
