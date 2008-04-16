Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYDPLMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYDPLMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 07:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYDPLMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 07:12:38 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:41409 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735AbYDPLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 07:12:38 -0400
Date: Wed, 16 Apr 2008 13:12:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: Self-snapshotting in Linux
Message-ID: <20080416111237.GA32432@atrey.karlin.mff.cuni.cz>
References: <ajbvb-3Ur-21@gated-at.bofh.it> <ajcri-65w-13@gated-at.bofh.it> <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da08e304-eb95-4ace-a069-de1a57b86e9f@e39g2000hsf.googlegroups.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ben Nizette wrote:
> > On Wed, 2008-04-16 at 16:44 +0800, Peter Teoh wrote:
> > > Essentially, to reiterate the key idea:   able to snapshot the current
> > > kernel+userspace permanent.....restore from another snapshot....and
> > > then switch back again if needed etc.....will the implementation be
> > > difficult...if not impossible????
> > >
> >
> > As I see it the main thing is that VMWare doesn't have to worry about
> > trying to put hardware in to (and pull out of) low power modes.  VMWare
> > hardware is never left in an undefined state by poorly written drivers
> > etc.
> >
> > I think hibernation is about what you want; snapshotting as you describe
> > it should fall down for about the same reasons
> 
> I guess there is the hardware / drivers issue.  I would like to claim
> I've found hibernation to be reliable but unfortunately that's not
> 100% true.  

So debug it, it is open source after all. Or at least file a bugs.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
