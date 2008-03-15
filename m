Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbYCOTsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbYCOTsX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 15:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYCOTry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 15:47:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1870 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752522AbYCOTrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 15:47:52 -0400
Date: Sat, 15 Mar 2008 14:32:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Phillips <phillips@phunq.net>
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315133242.GB4828@ucw.cz>
References: <200803092346.17556.phillips@phunq.net> <200803122317.24849.phillips@phunq.net> <47D8C9E8.6020908@davidnewall.com> <200803122350.56811.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803122350.56811.phillips@phunq.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-03-12 22:50:55, Daniel Phillips wrote:
> On Wednesday 12 March 2008 23:30, David Newall wrote:
> > Daniel Phillips wrote:
> > >> Your idea seems predicated on throwing large amounts of RAM at the
> > >> problem.  What I want to know is this: Is it really 25 times faster than
> > >> ext3 with an equally huge buffer cache?
> > >
> > > Yes.
> > 
> > Well, that sounds convincing.  Not.  You know this how?
> 
> By measuring it.  time untar -xf linux-2.2.26.tar; time sync

Thats cheating. Your ramback ignores sync.

Just time it against ext3 _without_ doing the sync. That's still more
reliable than what you have.

Heck, comment out sync and fsync from your kernel. You'll likely be 10
times normal speed, and still more reliable than ramback.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
