Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbZJBHLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbZJBHLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbZJBHLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:11:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38232 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbZJBHLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:11:05 -0400
Date: Fri, 2 Oct 2009 06:13:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.miao@marvell.com,
       Andrea Adami <andrea.adami@gmail.com>
Subject: Re: Zaurus suspend saga
Message-ID: <20091002041346.GC1409@ucw.cz>
References: <20090906052653.GB1324@ucw.cz> <1252276145.17852.15.camel@dax.rpnet.com> <f17812d70909061806y651c390w1faa5364f0fb6ddc@mail.gmail.com> <20090907110307.GK23450@elf.ucw.cz> <1252323270.14911.20.camel@hammer.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252323270.14911.20.camel@hammer.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-07 13:34:29, Stanislav Brabec wrote:
> Pavel Machek wrote:
> 
> > Yep, zaurus is currently pretty broken; I don't think charging from
> > Linux works at all, so I simply power down back to bootloader for
> > charge.
> > 
> > Anyway, suspend/resume is currently more important for me than charge,
> > and I'd like to get at least that to work.
> > 
> > Could we apply the trivial patch from "zaurus c3000 aka spitz: fix
> > resume" , and preferably push it to linus for 2.6.31? One version
> > where kernel suspends/resumes would be good. 
> 
> I vote for applying Pavel's patch, as it fixes suspend/resume. Emergency
> suspend may happen later, when SPI will be fully resumed. If future
> fixes provide early SPI resume, then this patch may be reverted.
> 
> Tested-by: Stanislav Brabec <utx@penguin.cz>
> 
> ...
> 
> Remaining Zaurus SL-C3200 problems in the current vanilla (regressions
> are compared with 2.6.26-RP):

Yep :-(. More developers/testers needed. People breaking zaurus all
the time, probably because they don't have the hw.

Should I get listed as zaurus maintainer so that I get to see
zaurus-breaking patches before they hit the mainline?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
