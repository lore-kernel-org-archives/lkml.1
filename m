Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbYCMVDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbYCMVDw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbYCMVDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:03:34 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56513 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbYCMVDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:03:33 -0400
Date: Thu, 13 Mar 2008 22:04:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>
Subject: Re: pm_register() and pm_send_all()
Message-ID: <20080313210411.GF4949@elf.ucw.cz>
References: <20080312150042.96668bcd.akpm@linux-foundation.org> <20080313092813.GA24027@elf.ucw.cz> <200803132154.59910.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803132154.59910.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-13 21:54:58, Rafael J. Wysocki wrote:
> On Thursday, 13 of March 2008, Pavel Machek wrote:
> > On Wed 2008-03-12 15:00:42, Andrew Morton wrote:
> > > 
> > > This:
> > > 
> > > kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
> > > kernel/power/pm.c:203: warning: 'pm_register' is deprecated (declared at kernel/power/pm.c:62)
> > > kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
> > > kernel/power/pm.c:204: warning: 'pm_send_all' is deprecated (declared at kernel/power/pm.c:178)
> > > 
> > > is getting a bit boring.  These were marked deprecated at least three years
> > > ago.
> > > 
> > > 
> > > pm_register() no longer has any callers and afacit can be removed
> > > immediately.
> > > 
> > > pm_send_all() has just a handful of callers:
> > > 
> > > arch/x86/kernel/apm_32.c
> > > arch/mips/au1000/common/power.c
> > > arch/frv/kernel/pm.c
> > 
> > AFAICT pm_send_all is a nop when noone uses pm_register...
> 
> Apparently on 2.6.24 it's not used anywehere, at least according to LXR.
> 
> > Hmm.. can we just force CONFIG_PM_LEGACY=n, and see what happens?
> 
> Do you want me to push this patch and the following one from Ralf to
> Len?

Yes... I think we can kill pm_send_all etc...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
