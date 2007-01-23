Return-Path: <linux-kernel-owner+w=401wt.eu-S965431AbXAWTDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965431AbXAWTDf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 14:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965436AbXAWTDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 14:03:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43374 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965431AbXAWTDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 14:03:35 -0500
Date: Tue, 23 Jan 2007 20:02:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070123190257.GF18662@elf.ucw.cz>
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <20070123190107.GB9219@inferi.kami.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123190107.GB9219@inferi.kami.home>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-01-23 20:01:07, Mattia Dongili wrote:
> On Tue, Jan 23, 2007 at 05:34:42PM +0100, Pavel Machek wrote:
> [...]
> > > Do you believe it could be a user-space daemon or what?
> > 
> > Yes, what prevents userspace daemon watching /dev/input/event* to
> > provide this functionality?
> 
> hmmm... EVIOCGRAB for example? the synaptics Xorg driver is using
> it, maybe others too?
> I don't want to start a new discussion about it, just provide an answer
> to your question :)

I do not know how EVIOCGRAB works, I believe event* will _still_ see
the events. Anyway, if not, I guess EVIOCGRAB can be fixed/removed/ we
can add EVIOCGIVEMEALLTHEDATAREALLYIWANTIT.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
