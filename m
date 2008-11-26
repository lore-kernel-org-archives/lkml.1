Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYKZNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYKZNPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYKZNPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:15:42 -0500
Received: from tservice.net.ru ([195.178.208.66]:50961 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbYKZNPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:15:41 -0500
Date: Wed, 26 Nov 2008 16:15:39 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Newall <davidn@davidnewall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, john@johnmccutchan.com,
       arnd@arndb.de, mtk.manpages@gmail.com, hch@lst.de, rlove@rlove.org,
       linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@suse.cz,
       Eric Paris <eparis@redhat.com>
Subject: Re: [take2] Inotify: nested attributes support.
Message-ID: <20081126131539.GA10172@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <492D4560.8000302@davidnewall.com> <20081126125113.GA8921@ioremap.net> <492D4927.8040204@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492D4927.8040204@davidnewall.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 11:33:35PM +1030, David Newall (davidn@davidnewall.com) wrote:
> > And as was shown it does not work for all cases and introduces unneded
> > performance overhead.
> 
> If the performance using a local loopback is insufficient, or even when
> using a UNIX domain socket, then it's going to be even worse for the
> actual network-connected clients.  And the cases were it doesn't work
> amount to poor system administration, which is a solvable problem.

Proposing to introduce additional overhead when it can be avoided is not
the best way to deal with the problem.
Another small detail, that it does not completely solve the problem.
 
> >> This change violates my first rule of programming: If there's two or
> >> more ways of solving a problem, pick one; don't pick them all.
> >
> > Then we should go back to caves, raw meat was so tasty...
> 
> Amusing, but irrelevant to programming.

Programming is so special, that new things which help having a progress
should not be developed there? Care to recall how to work with the punch
card? Following your logic inotify should be returned from the kernel,
since all applications which may do IO can be modified to first register
it in some special database and not checking IO at run-time. And we will
not care about others who did not do that.

Your 'rule' does not apply to the case, where is no way to solve the
problem completely using existing methods.

-- 
	Evgeniy Polyakov
