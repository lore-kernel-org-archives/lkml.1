Return-Path: <linux-kernel-owner+w=401wt.eu-S933457AbZJFWHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933457AbZJFWHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 18:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933336AbZJFWHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 18:07:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:44761 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641AbZJFWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 18:07:35 -0400
Date: Tue, 6 Oct 2009 17:06:49 -0500 (CDT)
From: manoj.iyer@canonical.com
To: Takashi Iwai <tiwai@suse.de>
cc: manoj.iyer@canonical.com, perex@perex.cz, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, Joey Stanford <joey@canonical.com>
Subject: Re: [PATCH REALTEK] Added quirk to enable sound on Toshiba NB200
In-Reply-To: <s5hljjprs71.wl%tiwai@suse.de>
Message-ID: <alpine.DEB.2.00.0910061705150.1980@little>
References: <alpine.DEB.2.00.0909230036570.29432@little> <s5h3a6eb46r.wl%tiwai@suse.de> <alpine.DEB.2.00.0909281022500.2112@little> <s5hd45agqoi.wl%tiwai@suse.de> <alpine.DEB.2.00.0909291812030.2426@little> <s5hhbulov3f.wl%tiwai@suse.de>
 <alpine.DEB.2.00.0910010208220.7813@little> <s5h1vlnjzaa.wl%tiwai@suse.de> <s5htyyivrpv.wl%tiwai@suse.de> <alpine.DEB.2.00.0910051912110.8725@little> <s5hljjprs71.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I can confirm that patch fixes broken mic on HP mini. It is labeled as 
"LineIn".

On Tue, 6 Oct 2009, Takashi Iwai wrote:

> At Mon, 5 Oct 2009 19:13:47 -0500 (CDT),
> manoj.iyer@canonical.com wrote:
>>
>>
>>
>> I am a little puzzled. The patch did not apply cleanly to the karmic
>> source tree, so I had to hand patch it. But, even with the quirk I
>> submitted, the patch you pointed me to killed sound again. Could I have
>> done something wrong?
>
> Try 2.6.32-rc3 kernel at best.  It already includes this fix.
> No reason to stick with the modified kernel just for testing.
>
> (And compiling a kernel won't take time if you set up kconfig properly.
> Even on a recent netbook, it's about 10 minutes.)
>
>
> thanks,
>
> Takashi
>
