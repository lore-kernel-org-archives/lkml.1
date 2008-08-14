Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbYHNN7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbYHNN7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 09:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbYHNN64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 09:58:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40515 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbYHNN6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 09:58:55 -0400
Date: Thu, 14 Aug 2008 15:50:21 +0200
From: Pavel Machek <pavel@suse.cz>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>,
       James.Bottomley@hansenpartnership.com,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
Subject: Re: [linux-pm] Power management for SCSI
Message-ID: <20080814135021.GE2262@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0808131138110.2151-100000@iolanthe.rowland.org> <200808131821.30564.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200808131821.30564.oneukum@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-13 18:21:29, Oliver Neukum wrote:
> Am Mittwoch 13 August 2008 17:44:46 schrieb Alan Stern:
> > > All children that are USB must be powered down. We know in fact that most
> > > drives don't care that the device is suspended. The problem was drive
> > > enclosures that cut power upon suspension losing cached data.
> > 
> > You misunderstood my question.  Are there SCSI transports other than
> > USB sharing the requirement that all child devices must be suspended
> > before the link can be powered down?
> 
> I dispute that USB in general has this property. Some storage devices
> need their caches flushed. USB itself is perfectly happy with autosuspending
> the storage device (host) without telling the disks (devices)
> 
> You could even argue that these storage devices violate the USB spec.

Hmm... but suspended devices have very little power budget, right?

So unless you have external power supply (2.5" frames generally
don't), you can't really suspend and stay spinned up...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
