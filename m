Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZI3AXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZI3AXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 20:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZI3AX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 20:23:29 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53737 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZI3AX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 20:23:29 -0400
Date: Tue, 29 Sep 2009 19:23:27 -0500 (CDT)
From: manoj.iyer@canonical.com
To: Takashi Iwai <tiwai@suse.de>
cc: manoj.iyer@canonical.com, perex@perex.cz, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH REALTEK] Added quirk to enable sound on Toshiba NB200
In-Reply-To: <s5hd45agqoi.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.00.0909291812030.2426@little>
References: <alpine.DEB.2.00.0909230036570.29432@little> <s5h3a6eb46r.wl%tiwai@suse.de> <alpine.DEB.2.00.0909281022500.2112@little> <s5hd45agqoi.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Thanks.  And what about my first question?

No, without the change sound does not work, and I can confirm this on 
NB200, NB205, and I hear that NB210 hass also the same hardware.

> Doesn't the latest driver work without your change?
> Try alsa-driver-snapshot tarball below if not tested yet.
>  ftp://ftp.kernel.org/pub/linux/kernel/people/tiwai/snapshot/alsa-driver-snapshot.tar.gz
>
> Or sound git tree master / for-next branches if you prefer kernel GIT:
>  git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git
>

I was not able to build the sound tree, but I installed the mainline 
kernel build (29th sept):

http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.31.1/

and sound does not work with that either.

>
> Takashi
>
>>
>> --- manjo
>>
>> On Wed, 23 Sep 2009, Takashi Iwai wrote:
>>
>>> At Wed, 23 Sep 2009 00:39:45 -0500 (CDT),
>>> Manoj Iyer wrote:
>>>>
>>>>
>>>>> From c96629e96fecbe59de7124ec913019ed378d0029 Mon Sep 17 00:00:00 2001
>>>> From: Manoj Iyer <manoj.iyer@canonical.com>
>>>> Date: Tue, 22 Sep 2009 18:33:29 -0500
>>>> Subject: [PATCH] [PATCH REALTEK] Added quirk to enable sound on Toshiba NB200
>>>>
>>>> Patch was tested on Toshiba NB200 and is found to enable sound.
>>>
>>> So, it doesn't work without the model quirk?
>>> Could you give alsa-info.sh output (run with --no-upload option)?
>>>
>>>
>>> thanks,
>>>
>>> Takashi
>>>
>>>>
>>>> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
>>>> Cc: stable@kernel.org
>>>> ---
>>>>   sound/pci/hda/patch_realtek.c |    1 +
>>>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
>>>> index 30eeb30..713bf69 100644
>>>> --- a/sound/pci/hda/patch_realtek.c
>>>> +++ b/sound/pci/hda/patch_realtek.c
>>>> @@ -16876,6 +16876,7 @@ static struct snd_pci_quirk alc662_cfg_tbl[] = {
>>>>   	SND_PCI_QUIRK(0x105b, 0x0cd6, "Foxconn", ALC662_ECS),
>>>>   	SND_PCI_QUIRK(0x105b, 0x0d47, "Foxconn 45CMX/45GMX/45CMX-K",
>>>>   		      ALC662_3ST_6ch_DIG),
>>>> +	SND_PCI_QUIRK(0x1179, 0xff6e, "Toshiba NB200", ALC663_ASUS_MODE4),
>>>>   	SND_PCI_QUIRK(0x144d, 0xca00, "Samsung NC10", ALC272_SAMSUNG_NC10),
>>>>   	SND_PCI_QUIRK(0x1458, 0xa002, "Gigabyte 945GCM-S2L",
>>>>   		      ALC662_3ST_6ch_DIG),
>>>> --
>>>> 1.6.3.3
>>>>
>>>>
>>>> --- manjo
>>>>
>>>
>
