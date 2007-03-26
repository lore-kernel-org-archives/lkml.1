Return-Path: <linux-kernel-owner+w=401wt.eu-S1752789AbXCZOea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbXCZOea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbXCZOea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:34:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:34841 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752789AbXCZOe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:34:29 -0400
Date: Mon, 26 Mar 2007 16:34:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Marcus Better <marcus@better.se>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Message-ID: <20070326143433.GC16477@stusta.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de> <200703261200.25587.marcus@better.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200703261200.25587.marcus@better.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2007 at 12:00:22PM +0200, Marcus Better wrote:
> Adrian Bunk wrote:
> > Subject    : ThinkPad R60: suspend to disk broken
> > References : http://lkml.org/lkml/2007/3/23/74
> > Submitter  : Marcus Better <marcus@better.se>
> > Status     : submitter tries to bisect
> 
> I just tried -rc5. Now suspend to disk seems to work. I think the XFS 
> workqueue patch fixed this.
> 
> It can also suspend to RAM, but resume is worse. The first time around it 
> resumed but corrupted the vesafb console (greenish blinking character cells), 
> something that used to work before. But the system responded to input, so I 
> suspended to RAM again. This time the resume failed, it hung after 
> printing "Linux!" in yellow at the top of the screen. (Seems to be some 
> artifact, I have seen it before even with working suspend.)
>...

Does setting CONFIG_PCI_MSI=n make any difference?

> Marcus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

