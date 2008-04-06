Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYDFKJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYDFKJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 06:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYDFKI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 06:08:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52112 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbYDFKI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 06:08:57 -0400
Date: Sun, 6 Apr 2008 13:08:26 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: apw@shadowen.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080406100826.GD30987@cs181133002.pp.htv.fi>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 06, 2008 at 06:54:54AM +0200, Jan Engelhardt wrote:
> ===
> total: 0 errors, 0 warnings, 36 lines checked
>
> d27a9f5.diff has no obvious style problems and is ready for submission.
> ===
> commit d27a9f5760fa231ab888f96e27355a001c88b239
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Sun Apr 6 06:49:01 2008 +0200
>
>     checkpatch: relax spacing and line length
>
>     We all had the arguments about 80 columns, so here goes a relax.
>     Checking for 95 (or perhaps something better?), but of course we
>     print "80" in the output, because if you happened to get to 95, it's
>     "really time" to break it.

No, it's really time to teach people that checkpatch is *not* a tool for 
janitors.

It's a tool for patch submitters and maintainers that automates a part 
of patch review.

When a patch has a few checkpatch warnings and the submitter can justify 
them (since the code would otherwise look bad) *that is OK*.

But if your driver has over 2000 lines over 80 columns or many lines 
over 95 columns it is not "really time to break it" - it is time to 
check *why* your code has that many that long lines.

>     This also relaxes the tab doctrine, because spaces DO make sense --
>     especially when you view the code with a tab setting of not-8.
>...

In the kernel all tabs are 8 spaces wide.

When you view the code with a different setting that's your fault.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

