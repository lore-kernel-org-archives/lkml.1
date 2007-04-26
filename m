Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbXDZFID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbXDZFID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 01:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbXDZFIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 01:08:02 -0400
Received: from 1wt.eu ([62.212.114.60]:2281 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbXDZFIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 01:08:00 -0400
Date: Thu, 26 Apr 2007 07:04:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426050438.GT943@1wt.eu>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426040806.GJ3468@stusta.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 06:08:06AM +0200, Adrian Bunk wrote:
> On Wed, Apr 25, 2007 at 08:29:28PM -0700, Linus Torvalds wrote:
> >...
> > So it's been over two and a half months, and while it's certainly not the 
> > longest release cycle ever, it still dragged out a bit longer than I'd 
> > have hoped for and it should have. As usual, I'd like to thank Adrian (and 
> > the people who jumped on the entries Adrian had) for keeping everybody on 
> > their toes with the regression list - there's a few entries there still, 
> > but it got to the point where we didn't even know if they were real 
> > regressions, and delaying things further just wasn't going to help.
> >...
> 
> 
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release:
> 14
> 
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release that were first reported in March or earlier:
> 8
> 
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release with patches available at the time of the 2.6.21 
> release [1]:
> 3
> 
> What I will NOT do:
> Waste my time with tracking 2.6.22-rc regressions.
> 
> 
> We have an astonishing amount of -rc testers, but obviously not the 
> developer manpower for handling them.
> 
> If we would take "no regressions" seriously, it might take 4 or 5 months 
> between releases due to the lack of developer manpower for handling 
> regressions. But that should be considered OK if avoiding regressions 
> was considered more important than getting as quick as possible to the 
> next two week regression-merge window.
> 
> But releasing with so many known regressions is insulting for the many 
> people who spent their time testing -rc kernels.

Adrian,

I understand your concerns, it's more and more common to see developers
considering their work is worthless. But it's not. You should see the
current development model as a pipeline. What you feed at the input can
take some time to reach the output, and if we wait for the whole pipeline
to flush, more crap gets released.

What is needed is a higher priority on fixes for known regressions. I
find your summary above more readable than the large lists of regressions.
I think that you should reply to Linus' announces with something that
short, starting from the known-with-patch, known-for-more-than-1-month,
and all-known-regressions. It may help Linus focus even more on those.
Also, while it will not prevent any release with regressions, at least
it will prevent such a stupid case of known regressions with patch
available.

Also, check how many regressions you have reported and which have been
fixed during the -rc stage. You'll see your work really was useful.

Maybe Linus should accept to dedicate -final to known regressions only,
to force a check in this area ? Whether or not all of them get fixed is
not the real problem, but at least we will not have any regressions with
pending patch unapplied !

Please do continue that task if you have the time to do so !

Thanks,
Willy

