Return-Path: <linux-kernel-owner+w=401wt.eu-S1762934AbYDVNI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762934AbYDVNI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYDVNIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:08:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3656 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753363AbYDVNIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:08:50 -0400
Date: Tue, 22 Apr 2008 15:00:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: APM lockups since 2.6.25
Message-ID: <20080422130013.GB5621@ucw.cz>
References: <Pine.LNX.4.64.0803191608500.25941@artax.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804162239560.25729@artax.karlin.mff.cuni.cz> <Pine.LNX.4.64.0804162243550.25729@artax.karlin.mff.cuni.cz> <200804170214.26368.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804170214.26368.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu 2008-04-17 02:14:25, Rafael J. Wysocki wrote:
> On Wednesday, 16 of April 2008, Mikulas Patocka wrote:
> > > So it didn't help, I just got this (2.6.25-rc8):
> > > 
> > > (I have turned lockdep on few days ago, and it seems to try to release a 
> > > lock that's not held ... and then reacquire that lock again and deadlock)
> > 
> > BTW. the first one message happened immediatelly after APM resume, the 
> > second message 2 minutes later.
> > 
> > APMD didn't set time after resume, it's completely locked up.
> 
> Well, unfortunately, APM uses the generic code for suspending and resuming
> devices, but it doesn't use the freezing of tasks, so it's not very reliable in
> its present form.

In theory, BIOS is reponsible for saving/restoring device state in APM
case... maybe we could just remove those calls?

If that works for mikulas, that already handles 50% of people using
apm ;-).

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
