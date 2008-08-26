Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYHZJ7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYHZJ7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHZJ7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:59:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38752 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbYHZJ7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:59:03 -0400
Date: Tue, 26 Aug 2008 11:44:26 +0200
From: Pavel Machek <pavel@suse.cz>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: autosuspend for SCSI devices
Message-ID: <20080826094426.GB30062@elf.ucw.cz>
References: <20080822105626.GA9475@elf.ucw.cz> <20080825194702.GA31007@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825194702.GA31007@dose.home.local>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-25 21:47:03, Tino Keitel wrote:
> On Fri, Aug 22, 2008 at 12:56:27 +0200, Pavel Machek wrote:
> > From: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Add support for autosuspend/autoresume of the SCSI devices. Lowlevel
> > driver can use it to spin the disk down... and it is neccessary step
> > for powering down the controllers.
> > 
> > Spinning down the disk is useful - saves ~0.5W here, and it is last
> > major thing we can do to save power on some small machines like
> > Kohjinsha subnotebooks.
> 
> Is there a difference regarding power saving to the already existing
> ways to spin down a disk, like noflushd? In a previous patch you
> mentioned that this can be used to disable the SATA port so save even
> more power. However, this part seems to be missing in this patch,
> right?

Correct. That is the plan for the next patch, when I get this one into
reasonable form for acceptance.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
