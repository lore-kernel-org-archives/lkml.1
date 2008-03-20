Return-Path: <linux-kernel-owner+w=401wt.eu-S1752058AbYCTXZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbYCTXZT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759669AbYCTXY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:24:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36315 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758140AbYCTXY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:24:27 -0400
Date: Fri, 21 Mar 2008 00:25:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Laurent Riffard <laurent.riffard@free.fr>,
       Pavel Emelyanov <xemul@openvz.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] ptrace: it is fun to strace /sbin/init
Message-ID: <20080320232503.GG17431@elf.ucw.cz>
References: <20080316155455.GA20848@tv-sign.ru> <20080320162718.GA4397@ucw.cz> <20080320165756.GA11197@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320165756.GA11197@tv-sign.ru>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-20 19:57:56, Oleg Nesterov wrote:
> On 03/20, Pavel Machek wrote:
> > 
> > > Ptracing of /sbin/init is not allowed. Of course, this is very dangerous, but
> > > may be useful. Introduce the kernel boot parameter to allow this.
> > ...
> > > @@ -803,6 +803,8 @@ and is between 256 and 4096 characters. 
> > >  			Run specified binary instead of /sbin/init as init
> > >  			process.
> > >  
> > > +	init_ptrace	[KNL] Allows to ptrace init. Very dangerous. Don't use.
> > > +
> > 
> > I don't know what ptracing init is good for, and I believe people
> > wanting to do this kind of special stuff can patch their own kernel...
> 
> Yes sure. But could you explain why this can be bad given that ptracing
> init needs the explicit boot parameter? IOW, could you explain why you
> don't like this small and trivial change which adds a minimal impact?

"It can't be bad, its optional".

It is bad exactly _because_ it is optional. Anything that adds boot
parameter is *not* trivial... 

Why not add

please_randomly_corrupt_memory boot parameter? It may be useful for
something...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
