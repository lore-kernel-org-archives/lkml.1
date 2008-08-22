Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbYHVUZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbYHVUZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbYHVUYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:24:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52682 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYHVUYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:24:53 -0400
Date: Fri, 22 Aug 2008 12:52:46 +0200
From: Pavel Machek <pavel@suse.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, teheo@novell.com
Subject: Re: [linux-pm] Power management for SCSI
Message-ID: <20080822105246.GB3482@elf.ucw.cz>
References: <200808191533.15244.oneukum@suse.de> <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0808191108440.2669-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > - suspending has side effects
> 
> I'm not sure what you mean by that.  Suspension always has side effects 
> of one kind or another.
> 
> > Suspension in USB has always side effects. That's not true for other
> > subsystems.
> 
> Name one.  At the very least, suspending a device means you can't use
> it again without first calling the driver's resume method.  That's a 
> side effect.

IDE, actually. I don't think it is relevant, but you can do hdparm -y,
and it will automatically spin up when you try to talk to it next
time.

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
