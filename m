Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYIDGvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYIDGvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 02:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYIDGvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 02:51:41 -0400
Received: from cable.insite.cz ([84.242.84.93]:35689 "EHLO server.insite.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750870AbYIDGvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 02:51:40 -0400
X-Greylist: delayed 1114 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 02:51:40 EDT
Message-ID: <48BE7EE4.8020800@insite.cz>
Date: Wed, 03 Sep 2008 14:11:16 +0200
From: Pavel Hofman <pavel.hofman@insite.cz>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Wei Ni <wni@nvidia.com>, Peer Chen <pchen@nvidia.com>,
       alsa-devel <alsa-devel@alsa-project.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [alsa-devel] [PATCH] add the nvidia HDMI codec driver for	MCP77/79
References: <200809031558156739794@gmail.com> <s5hhc8xpq6z.wl%tiwai@suse.de>	<15F501D1A78BD343BE8F4D8DB854566B31F8F744@hkemmail01.nvidia.com> <s5h4p4xph6x.wl%tiwai@suse.de>
In-Reply-To: <s5h4p4xph6x.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> ......
>> According to these codes, It only can get the realtek codec and can not
>> get hdmi codec, if just change azx_max_codecs[AZX_DRIVER_NVIDIA] to 4
>> I think if remove "if (!audio_codecs)", it will be better, and I only
>> need to chang azx_max_codecs[AZX_DRIVER_NVIDIA] to 4
> 
> Well, the check is there for a good reason.
> 
> There are many machines with broken BIOS reporting the 4th slot
> available although it isn't actually.  It's a workaround to skip such
> a bogus information.  So, it cannot be changed so easily.
> 
> We need to sort out this in a better way...  Oh well.


Please, please, put the above information as a comment to the respective 
place. These "hacks" should be commented :)

Thanks a lot,

Pavel.

