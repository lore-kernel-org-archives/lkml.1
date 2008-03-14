Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYCNIDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYCNIDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 04:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCNIDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 04:03:39 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43085 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYCNIDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 04:03:38 -0400
Date: Fri, 14 Mar 2008 09:04:15 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, ralf@linux-mips.org
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080314080415.GC9465@elf.ucw.cz>
References: <20080312150042.96668bcd.akpm@linux-foundation.org> <21968.1205411497@redhat.com> <20080313180558.GC4949@elf.ucw.cz> <20080313112614.cae39f86.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313112614.cae39f86.akpm@linux-foundation.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 11:26:14, Andrew Morton wrote:
> On Thu, 13 Mar 2008 19:05:58 +0100
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > On Thu 2008-03-13 12:31:37, David Howells wrote:
> > > Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > pm_send_all() has just a handful of callers:
> > > 
> > > What should be done instead of calling pm_send_all()?
> > 
> > pm_send_all is currently nop.
> 
> So we could have deleted pm_send_all() and pm_register() ages ago?  And
> we've all been needlessly staring at those warnings all this time? 
> Grumble.

we could have deleted pm_send_all when users of pm_register were gone,
yes.... just nobody noticed :-(.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
