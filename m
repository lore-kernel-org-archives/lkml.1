Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZJ1V4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZJ1V4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbZJ1V4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:56:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56019 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZJ1V4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:56:14 -0400
Date: Wed, 28 Oct 2009 22:56:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091028215612.GB8053@elf.ucw.cz>
References: <20091022091333.GA31023@elf.ucw.cz>
 <20091026234332.GB26583@kroah.com>
 <20091027001702.GA5019@elf.ucw.cz>
 <20091027030039.GA6195@kroah.com>
 <20091027081921.GG5019@elf.ucw.cz>
 <20091027165750.GA24477@kroah.com>
 <20091027193330.GB19379@elf.ucw.cz>
 <20091027204445.GA28878@kroah.com>
 <20091027232521.GA16782@elf.ucw.cz>
 <20091028155116.GA1434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091028155116.GA1434@kroah.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > With this patch, will it build properly?
> > 
> > Its certainly way closer to building... it builds for me, with
> > something like below; platform devices really are initialized from
> > board-* files and get passed parameters.
> 
> Ick.  This isn't ok, we can't take patches for staging stuff in files
> outside of drivers/staging/

I know, I was trying to show that ammount of required changes is very small.

> So for now, I've deleted the drivers/staging/dream/ directory from my
> tree, which will get pushed for 2.6.33.  Please clean the code up and
> get it into buildable shape and I will be glad to add the drivers back
> into the staging directory at that time.

Ok, I got something that builds; verifying it on device is hard, as
last kernel that boots there is 2.6.29...

Should I turn it into series and submit?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
