Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYCXXJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYCXXJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 19:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYCXXIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 19:08:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35910 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYCXXIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 19:08:52 -0400
Date: Tue, 25 Mar 2008 00:09:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: it is fun to strace /sbin/init
Message-ID: <20080324230930.GE2426@elf.ucw.cz>
References: <20080323135110.GA294@tv-sign.ru> <20080324160102.GB4069@atrey.karlin.mff.cuni.cz> <20080324164059.GA4767@tv-sign.ru> <20080324223925.GD2426@elf.ucw.cz> <20080324230458.GA173@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080324230458.GA173@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-03-25 02:04:58, Oleg Nesterov wrote:
> On 03/24, Pavel Machek wrote:
> >
> > > /sbin/init is important, but there are other important (and sometimes
> > > much more important) services. Why it is so special so that we can't
> > > debug/strace it?
> > 
> > Maybe. Let's kill /sbin/init protection in 2.6.26. But making it
> > optional is wrong.
> 
> You are right, the boot parameter is silly. How about sysctl?

I'd prefer it to be hardcoded, really.

"You can kill /sbin/init" sounds right.

"You can kill /sbin/init on 2.6.26+" sounds... still quite ok.

"You can kill /sbin/init on 2.6.26+ if you have /proc/sys/foo/bar ==
1" sounds... quite wrong.

> Stephen, do you see any security problems if we make /sbin/init
> ptraceable by default?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
