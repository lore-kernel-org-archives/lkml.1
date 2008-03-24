Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbYCXWiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbYCXWiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 18:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYCXWis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 18:38:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:53190 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYCXWir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 18:38:47 -0400
Date: Mon, 24 Mar 2008 23:39:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324223925.GD2426@elf.ucw.cz>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324164059.GA4767@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > @@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
> > >  			Run specified binary instead of /sbin/init as init
> > >  			process.
> > >  
> > > +	init_ptrace	[KNL] Allows to ptrace init.
> > > +
> > 
> > No words about it being dangerous, but I believe it is.
> 
> it is, admin should know what he does,
> 
> > If it is not, lets do the patch, but not optional.
> 
> This will change the default historical behaviour, I can't predict
> does this matter for (say) SELinux or not. Otherwise I'd personally
> prefer to always allow to ptrace init.
> 
> > If it is dangerous, option does not make it better.
> 
> ptrace() is always dangerous. ptracer can crash oracle and lose data.
> 
> /sbin/init is important, but there are other important (and sometimes
> much more important) services. Why it is so special so that we can't
> debug/strace it?

Maybe. Let's kill /sbin/init protection in 2.6.26. But making it
optional is wrong.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
