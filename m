Return-Path: <linux-kernel-owner+w=401wt.eu-S1762058AbYBSLYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762058AbYBSLYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbYBSLW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:22:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45878 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758504AbYBSLWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:55 -0500
Date: Tue, 19 Feb 2008 11:12:46 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Brownell <david-b@pacbell.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON(): proc_dir_entry 'rtc' already registered
Message-ID: <20080219101246.GB2202@elf.ucw.cz>
References: <20080212132626.GA1534@elf.ucw.cz> <200802121029.08007.david-b@pacbell.net> <20080218105441.GE7198@elf.ucw.cz> <200802180308.17115.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802180308.17115.david-b@pacbell.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-02-18 03:08:16, David Brownell wrote:
> On Monday 18 February 2008, Pavel Machek wrote:
> > > How to fix ... how about:  instead of just warning folk
> > > off such legacy RTC drivers [1] we just wrap them with
> > > an "if RTC_LIB != n" so this mistake won't be possible.
> > 
> > Yes, disabling bad configs in Kconfig seems like way to go.
> 
> Problem is ... that also disables valid configs that
> get assembled by picking the right module(s) for the
> target system.

Is there any reason to use the old rtc subsystem?

At least OLD_RTC=y NEW_RTC=y should be disabled... even if OLD_RTC=m
NEW_RTC=m makes some sense.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
