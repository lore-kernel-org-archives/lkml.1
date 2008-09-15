Return-Path: <linux-kernel-owner+w=401wt.eu-S1756879AbYIOV1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879AbYIOV1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 17:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYIOV10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 17:27:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52733 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYIOV1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 17:27:25 -0400
Date: Mon, 15 Sep 2008 21:59:53 +0200
From: Pavel Machek <pavel@suse.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.27-rc6: nohz + s2ram = need to press keys to get progress
Message-ID: <20080915195951.GA1651@elf.ucw.cz>
References: <alpine.LFD.1.10.0809140455470.5283@apollo.tec.linutronix.de> <20080914100913.GB7909@elf.ucw.cz> <20080914101406.GA1625@elf.ucw.cz> <20080914173536.GA1687@elf.ucw.cz> <alpine.LFD.1.10.0809141049570.5283@apollo.tec.linutronix.de> <20080914181228.GA18934@elf.ucw.cz> <alpine.LFD.1.10.0809141214110.5283@apollo.tec.linutronix.de> <20080915091925.GB1787@elf.ucw.cz> <alpine.LFD.1.10.0809150704420.5283@apollo.tec.linutronix.de> <20080915192600.GA1627@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080915192600.GA1627@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > to
> > 
> > 72d43d9bc9210d24d09202eaf219eac09e17b339
> 
> cg-seek here, and problem is back. Good. I can get the
> /proc/timer_list ;-)... attached.

(Actually, timer_list was from more recent kernel, sorry about that, I
was confused. But I verified, and 72d... is still broken).

Trying commit 7cfb0435330364f90f274a26ecdc5f47f738498c now... bad,
too.

Trying 1fb9b7d29d8e85ba3196eaa7ab871bf76fc98d36... bad, too.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
