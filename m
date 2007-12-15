Return-Path: <linux-kernel-owner+w=401wt.eu-S1758772AbXLOWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbXLOWyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 17:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbXLOWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 17:54:11 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35312 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751766AbXLOWyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 17:54:10 -0500
Date: Sat, 15 Dec 2007 23:54:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <ak@suse.de>, Avi Kivity <avi@qumranet.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, mingo@elte.hu,
       ehabkost@redhat.com, jeremy@goop.org, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 4/8] unify paravirt parts of system.h
Message-ID: <20071215225419.GB2434@elf.ucw.cz>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <4755A809.4050305@qumranet.com> <20071204193432.GI11764@bingen.suse.de> <20071205163017.GA4756@ucw.cz> <20071215132638.GA28231@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215132638.GA28231@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2007-12-15 14:26:38, Andi Kleen wrote:
> > It probably is safe to remove... but we currently support '2.8.95
> > kernel loads/resumes 2.6.24 image'... which would break if 2.8 uses
> > cr8.
> 
> No it won't. 2.8 would just restore some random useless value.

Restoring random value seems wrong. Putting random values into cpu
registers can break stuff, right?

Even if 2.6.24 image being restored did not set %cr8 itself, it may
depend on %cr8 to have "sane" value.

> If 2.8 wants to use CR8 it would have to re-initialize it

We are talking "2.8 restores 2.6 image" here.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
