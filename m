Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYHLV5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYHLV5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbYHLV5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:57:19 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43541 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbYHLV5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:57:18 -0400
Date: Tue, 12 Aug 2008 23:58:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "arjan@infradead.org" <arjan@infradead.org>
Subject: Re: [RFC] Imprecise timers.
Message-ID: <20080812215834.GB12911@elf.ucw.cz>
References: <1216695757.18980.16.camel@shinybook.infradead.org> <7E82351C108FA840AB1866AC776AEC4608E23BE7@orsmsx505.amr.corp.intel.com> <20080809125447.GA13169@ucw.cz> <20080811173526.GA28661@linux-os.sc.intel.com> <20080812120031.GD8806@elf.ucw.cz> <20080812181126.GA30061@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812181126.GA30061@linux-os.sc.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Instead a rounded timer after 5 seconds still ensures atleast 1s idle time on
> the CPU without the overhead.
> 
> There can be many users who really don't care about the deadline or can happliy
> use rounded timers or deferrable timers. Say garbage collectors, cache_reap
> and friends, ondemand governor, vga cursor blinking comes to my mind.

Ok, maybe.

But don't try to play with vga cursor blinking; any irregularity there
will be _very_ visible_.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
