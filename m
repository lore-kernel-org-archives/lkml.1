Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbZHELfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbZHELfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZHELfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:35:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbZHELfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:35:10 -0400
Message-ID: <4A796E5D.2090707@suse.de>
Date: Wed, 05 Aug 2009 20:34:53 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Takashi Iwai <tiwai@suse.de>, Colin Guthrie <cguthrie@mandriva.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A794FB9.30403@mandriva.org>	<20090805105916.28f84a05@lxorguk.ukuu.org.uk>	<s5h63d2o9ds.wl%tiwai@suse.de>	<20090805112649.4a59ce70@lxorguk.ukuu.org.uk>	<s5hzlaemtdx.wl%tiwai@suse.de> <20090805121551.7449f748@lxorguk.ukuu.org.uk>
In-Reply-To: <20090805121551.7449f748@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> This makes it worse.
>> Well, the only regression would be the case where you create static
>> /dev/dsp (or else) devices and let auto-loading through sound-slot-*
>> or sound-service-*-* aliases.  Of course, this still works if you
>> load soundcore in some way.
> 
> Unless some ugly cuse hack got there first.
> 
>> What I suggested in the above is to cut off an unneeded dependency
>> between soundcore and ALSA-native stuff instead of hacking soundcore.
>> It won't change anything else, so everything else can coexist as
>> before.
> 
> Agreed - but that is really a separate issue to having something break
> the soundcore by being rude.

Sigh, does the wording really have to be 'ugly' and 'rude'?
sound_core.c itself is a strange hack at this point.  :-(

-- 
tejun
