Return-Path: <linux-kernel-owner+w=401wt.eu-S933470AbXCTJ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933470AbXCTJ7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 05:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933502AbXCTJ7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 05:59:04 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56209 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933470AbXCTJ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 05:59:02 -0400
Date: Tue, 20 Mar 2007 10:56:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Adrian Bunk <bunk@stusta.de>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Odd suspend regression in 2.6.21-rc[123]
Message-ID: <20070320095638.GA19137@elf.ucw.cz>
References: <45F0C018.2020409@madrabbit.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0C018.2020409@madrabbit.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> In 2.6.21-rc1,2,3, my laptop will fully suspend to ram, but then
> *immediately* resumes back from suspension. (It resumes just fine, as well.)
> 
> Nothing out of the ordinary is logged, and this happens even when
> booting into init=/bin/sh with minimal modules loaded and executing
> s2ram from that minimal environment.
> 
> I'm going to ponder the 2.6.20 to 2.6.21-rc1 changelog, but I'm hoping
> someone with a clue can offer a suggestion before I end up bisecting the
> whole thing. (Wouldn't be so bad, except I'm given to understand that
> there are multiple places in those changes where nothing quite works
> with respect to suspend.)
> 
> HP/Compaq NX6125 system, AMD64, dmesg attached.

Known problem in ACPI, hopefully already fixed?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
