Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbXHUGaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbXHUGaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754571AbXHUGaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:30:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60113 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbXHUGaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:30:08 -0400
Subject: Re: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-usb-devel@lists.sourceforge.net, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Stuart_Hayes@Dell.com" <Stuart_Hayes@dell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Exner <dex@dragonslave.de>
In-Reply-To: <alpine.LFD.0.999.0708202316430.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
	 <200708202102.58508.david-b@pacbell.net>
	 <alpine.LFD.0.999.0708202106290.30176@woody.linux-foundation.org>
	 <200708202148.45575.david-b@pacbell.net>
	 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
	 <1187675488.2676.3.camel@laptopd505.fenrus.org>
	 <alpine.LFD.0.999.0708202316430.30176@woody.linux-foundation.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 20 Aug 2007 23:24:47 -0700
Message-Id: <1187677487.2676.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.90 (2.11.90-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-08-20 at 23:25 -0700, Linus Torvalds wrote:

> Do we actually have the latency information for these things? Especially 
> since I assume a number of people use the specialized direct-hw-access 
> cpufreq drivers..
> 
> I realize that we *have* "transition_latency" at the cpufreq layer, and it 
> is supposed to be in ns, but I wonder how likely it is to bear any 
> relationship to reality, considering that I don't think it's really used 
> for anything.. (yeah, it affects the heuristics, but I don't think it has 
> any _hard_ meaning, so I'd worry that it's not necessarily something that 
> people have tried to make accurate).

trusting the bios to be accurate for all machines is generally a ...
well... it's like trusting politicians in election week.

But it's sort of the best we got; at the same time, what are the odds
that the time is more than an order of magnitude off? if the latency of
the cpu is so large that the requirement ehci puts in is orders of
magnitude more strict, a bit inaccurate data from the bios doesn't
matter all that much. And worst case we make a table with quirks somehow
(probably on cpu vendor/model I suppose)

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

