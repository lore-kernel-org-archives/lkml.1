Return-Path: <linux-kernel-owner+w=401wt.eu-S1764018AbXHCXzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764018AbXHCXzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 19:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760326AbXHCXzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 19:55:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40596 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760259AbXHCXzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 19:55:01 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708032152060.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032116340.1817@scrub.home>
	 <1186170407.3153.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708032152060.1817@scrub.home>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 03 Aug 2007 16:53:49 -0700
Message-Id: <1186185229.3153.11.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Actually the hrsleep() function would allow for submillisecond sleeps, 
> which might be what some of the 450 users really want and they only use
> msleep(1) because it's the next best thing.
> A hrsleep() function is really what makes most sense from an API 
> perspective.

I respectfully disagree. The power of msleep is that the unit of sleep
time is in the name; so in your proposal it would be hr_msleep or
somesuch. I much rather do the opposite in that case; make the "short"
name be the best implementation of the requested behavior, and have
qualifiers for allowing exceptions to that... least surprise and all
that.
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

