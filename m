Return-Path: <linux-kernel-owner+w=401wt.eu-S932370AbZDJJUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbZDJJUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763982AbZDJJUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:20:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38296 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449AbZDJJUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:20:23 -0400
Date: Fri, 10 Apr 2009 11:23:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-pm@lists.linux-foundation.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] Regression: First hibernation attempt fails
Message-ID: <20090410092318.GB30093@elf.ucw.cz>
References: <49DDD83F.507@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DDD83F.507@tuffmail.co.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-04-09 12:13:03, Alan Jenkins wrote:
> Yet another issue in 2.6.30-rc1 which was not present in 2.6.29 :-).  I
> wonder if it rings any bells?
> 
> On my laptop (EEE 4G), the first attempt at hibernation fails. 
> Subsequent attempts succeed.
> 
> If I use s2disk as normal, I see "snapshotting system", then before it
> gets to write out the image, it aborts and switches back to X.   I can't
> see any error message, even if I check the log with "dmesg".
> 
> If I use "echo disk > /sys/power/state", echo reports the error "Cannot
> allocate memory".
> 
> This only happens if I've logged in to X first.  In fact, I narrowed it
> down to gnome-power-manager.  If I kill gnome-power-manager beforehand,
> then it doesn't happen.

Anything interesting in dmesg?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
