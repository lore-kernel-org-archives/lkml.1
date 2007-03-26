Return-Path: <linux-kernel-owner+w=401wt.eu-S933559AbXCZEQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559AbXCZEQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 00:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933404AbXCZEQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 00:16:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:45476 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581AbXCZEQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 00:16:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=X67zyY7c5IOgmzKONbH0iJxgd4+kDJO6kf6B61rSq1ksGm4aJfX6X0uGOpMSLGc/W6l4ON+SE/KHh8g20vzBwr4Mbwcv4yJNzCS1Vvl4viXBK3ZTwrr5gbXTTBR7RWrBJ/PlhshsjACPwLPolmmcIYVk5/XPq8norvVzSVpKEho=
Message-ID: <75b66ecd0703252116m5216ec8dy78528f512ae63747@mail.gmail.com>
Date: Mon, 26 Mar 2007 00:16:09 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [2.6.22 patch] more scheduled OSS driver removal
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4607213B.9070005@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070324130602.GD752@stusta.de> <4607213B.9070005@student.ltu.se>
X-Google-Sender-Auth: 5ad81cf0bf6845f5
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Adrian Bunk wrote:
> > This patch contains the scheduled removal of OSS drivers that:
> > - have ALSA drivers for the same hardware without known regressions and
> > - whose Kconfig options have been removed in 2.6.20.
> >
> Sorry for this late respond
>
> Is sound/oss/emu10k1/ really ready to be replaced? According to a friend
> of mine, who got the hardware, the ALSA still lacks feature provided by
> the OSS-driver. He mentioned some sort of programmable memory (forgot
> the name for that) with whom you can run small programs to manipulate
> the sounds (adding echo and such).

He's referring to EMU DSP manager.  (emudspmgr I think it's called).
The ALSA equivalent is ld10k1.  It might not be as mature as the OSS
equivalent, but are we really going to keep obsolete drivers in the
kernel just because the userspace tools for the old driver are more
mature?

> Also, he got problems with getting
> more accurate control of the volume (guess this is more a userland issue).
> He seems to have done his homework but only got to pages where other
> peoples had the same problem.
>

I guess he's referring to the well known "Master volume only controls
front output" problem.  This really does need to be resolved, as many
other ALSA drivers are effected.

Lee
