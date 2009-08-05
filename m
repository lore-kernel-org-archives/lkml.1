Return-Path: <linux-kernel-owner+w=401wt.eu-S934281AbZHEMfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934281AbZHEMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbZHEMfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:35:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45303 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934227AbZHEMfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:35:32 -0400
Message-ID: <4A797C84.2050109@suse.de>
Date: Wed, 05 Aug 2009 21:35:16 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Colin Guthrie <cguthrie@mandriva.org>,
       Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
References: <4A79283E.7030202@kernel.org>	<4A79296A.4090600@suse.de>	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>	<4A794FB9.30403@mandriva.org>	<20090805105916.28f84a05@lxorguk.ukuu.org.uk>	<s5h63d2o9ds.wl%tiwai@suse.de>	<20090805112649.4a59ce70@lxorguk.ukuu.org.uk> <s5hzlaemtdx.wl%tiwai@suse.de>
In-Reply-To: <s5hzlaemtdx.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> Well, the only regression would be the case where you create static
> /dev/dsp (or else) devices and let auto-loading through sound-slot-*
> or sound-service-*-* aliases.  Of course, this still works if you
> load soundcore in some way.

If we're gonna do that, we might as well just rip off the pointless
'claim everything so we can use our own module alises' code from
sound_core.c and be done with it.  That really is the only problem.

Thanks.

-- 
tejun
