Return-Path: <linux-kernel-owner+w=401wt.eu-S934225AbZLFVLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934225AbZLFVLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:11:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932761AbZLFVLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:11:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57318 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbZLFVLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:11:09 -0500
Date: Sun, 6 Dec 2009 22:11:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "lee.schermerhorn@hp.com" <lee.schermerhorn@hp.com>, stable@kernel.org
Subject: Re: aim7 scalability issue on 4 socket machine
Message-ID: <20091206211105.GA13917@elf.ucw.cz>
References: <1253179879.2606.37.camel@ymzhang>
 <1253180411.8497.1.camel@twins>
 <Pine.LNX.4.64.0909171122180.25864@sister.anvils>
 <1253239339.2606.40.camel@ymzhang>
 <20090917195909.3a00ef83.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0909180742500.14561@sister.anvils>
 <20090918000542.268934e1.akpm@linux-foundation.org>
 <20091206200833.GA2357@elf.ucw.cz>
 <20091206201136.GZ18989@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206201136.GZ18989@one.firstfloor.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-06 21:11:36, Andi Kleen wrote:
> >  - It must be obviously correct and tested.
> >  - It cannot be bigger than 100 lines, with context.
> >  - It must fix only one thing.
> >  - It must fix a real bug that bothers people (not a, "This could be a
> >    problem..." type thing).
> 
> A significant slow down in a common situation is a "significant
> bug that bothers people"

Well, IIRC it was benchmark that was slowed down, on huge system, so
it was exactly "this could be a problem".

Anyway, I don't care about -stable series too much (and sorry for
replying to such an old mail), but perhaps the docs should be updated?

Examples cited there are such as "data corruption" or "oops", which is
clearly different ballpark then "slowdown".
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
