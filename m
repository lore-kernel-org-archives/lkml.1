Return-Path: <linux-kernel-owner+w=401wt.eu-S1752151AbXCaVLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbXCaVLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 17:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXCaVLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 17:11:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:39506 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752151AbXCaVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 17:11:32 -0400
Date: Sat, 31 Mar 2007 23:11:30 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove the config option for the cs5530a_warm_reset() quirk
Message-ID: <20070331211130.GE14134@stusta.de>
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331205530.GZ14134@stusta.de> <460ECD13.4000603@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <460ECD13.4000603@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2007 at 02:05:23PM -0700, Jeremy Fitzhardinge wrote:
> Adrian Bunk wrote:
> > Instead of cleaning up this mess, please replace this patch with the 
> > patch below.
> >   
> 
> Yeah, I considered that patch as a placeholder; I'd been wondering if it
> can be completely removed.
> 
> But this patch looks fine, though I'd go further - the lookup table of
> pci ids is overkill since it only has one entry (and doesn't look likely
> to grow any more).

I have no strong opinion regarding this - if it's agreed upon that it's 
unlikely it will ever grow, I can also send an additional patch 
simplifying it.

>     J

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

