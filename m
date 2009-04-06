Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZDFMCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZDFMCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 08:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZDFMBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 08:01:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZDFMBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 08:01:54 -0400
Date: Mon, 6 Apr 2009 14:01:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: TOMOYO in linux-next
Message-ID: <20090406120137.GA12468@elf.ucw.cz>
References: <20090326215031.GD29836@elf.ucw.cz> <alpine.LRH.2.00.0903271102240.7492@tundra.namei.org> <200903270412.n2R4CG7o054009@www262.sakura.ne.jp> <200904062049.AFJ90113.JFOOSFOVQHLFMt@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904062049.AFJ90113.JFOOSFOVQHLFMt@I-love.SAKURA.ne.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-04-06 20:49:14, Tetsuo Handa wrote:
> Hello.
> 
> > > +#ifdef TOMOYO_DEBUG_DOMAIN_UNDELETE
> > > +                       if (domain2->is_deleted != 255)
> > > +                               printk(KERN_DEBUG
> > > +                                      "Marked %p as non undeletable\n",
> > > +                                      domain2);
> > > +#endif
> > > +                       domain2->is_deleted = 255;
> > > 
> > > (I don't know why we want undelete in tomoyo.)
> > This "undelete domain" feature was introduced to allow administrators switch
> > domain policy periodically.
> > 
> We reconsidered this feature and concluded that we won't need this feature.

Thanks.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
