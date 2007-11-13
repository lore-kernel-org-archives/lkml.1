Return-Path: <linux-kernel-owner+w=401wt.eu-S1759175AbXKMGEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175AbXKMGEx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 01:04:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750704AbXKMGEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 01:04:45 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34353 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750699AbXKMGEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 01:04:45 -0500
Date: Tue, 13 Nov 2007 07:04:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
Message-ID: <20071113060422.GR9771@stusta.de>
References: <20071111064829.GG21669@stusta.de> <47387E32.4050206@t-online.de> <20071112164023.GL9771@stusta.de> <4738CEBB.8000501@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4738CEBB.8000501@t-online.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 11:07:55PM +0100, Bernd Schmidt wrote:
> Adrian Bunk wrote:
> > It can be a performance regression, but there are also cases where it 
> > can improve performance. If gcc produces lower performance code that
> > would be a bug in gcc that should be reported, but using a division is 
> > not generally wrong.
> > 
> > A more clearer example might be:
> > 
> > <--  snip  -->
> > 
> > void foo(u64 ns)
> > {
> > 	if (ns < 10000)
> > 		return;
> > 
> > 	while(ns >= 3) {
> > 		ns -= 3;
> > #ifdef DEBUG
> > 		bar(ns);
> > #endif
> > 	}
> > }
> > 
> > <--  snip  -->
> > 
> > With DEBUG not defined you can hardly argue gcc should be fixed to not 
> > use a division for performance reasons.
> 
> Absent any clear information about the possible values of ns,
>...

In this example, there is clear information about the possible values
of ns...

> Bernd

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

