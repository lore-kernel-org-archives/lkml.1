Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZEYMcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZEYMcm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 08:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZEYMce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 08:32:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41423 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbZEYMcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 08:32:33 -0400
Date: Mon, 25 May 2009 14:32:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
Message-ID: <20090525123228.GA13446@elf.ucw.cz>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net> <200905082144.57955.bzolnier@gmail.com> <1241819971.19600.288.camel@nigel-laptop> <200905090105.58243.bzolnier@gmail.com> <1241824525.19600.369.camel@nigel-laptop> <20090509135820.GF10859@elf.ucw.cz> <1243243666.16743.64.camel@nigel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243243666.16743.64.camel@nigel-laptop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-05-25 19:27:46, Nigel Cunningham wrote:
> Hi.
> 
> On Sat, 2009-05-09 at 15:58 +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > Instead of new features I would rather see more effort being put into making
> > > > the _core_ TuxOnIce (I mean patch #8 here) smaller (8 KLOC is still a lot,
> > > > just to put things into the right perspective the current in-kernel content
> > > > of kernel/power/ is 5.5 KLOC) and with more documentation inside the code.
> > > 
> > > Yeah, but those 2.5k extra lines get you more reliability and extra
> > > functionality. They're not fat.
> > 
> > If you know about reliability problems in swsusp, please fix them in
> > separate patch. Hiding the fixes in 8KLOC patch is not nice.
> 
> I'm going to try to. Unfortunately, they'll require what's basically a
> group-up redesign of the basic algorithm, because to get maximum
> reliability, you need to carefully account for the amount of storage
> you're going to need and the amount of memory you have available, and
> 'prepare' the image prior to doing the atomic copy.

I don't quite get it; why is that needed?

If there's not enough swap available, swsusp should freeze, realize
there's no swap, unfreeze and continue. I do not see reliability
problem there.

If there are some problems like "it crashes during suspend or resume"
or "suspend succeeds but fails to resume", we'd like to fix those with
priority...
 
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
