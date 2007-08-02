Return-Path: <linux-kernel-owner+w=401wt.eu-S1758168AbXHBQIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbXHBQIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755102AbXHBQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:07:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4246 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754355AbXHBQHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:07:55 -0400
Date: Thu, 2 Aug 2007 16:07:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: trenn@suse.de, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       mjg59@srcf.ucam.org, lenb@kernel.org,
       Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802160742.GA4415@ucw.cz>
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <46B1C0BA.1020004@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B1C0BA.1020004@t-online.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Well, it would not be the first time to eliminate a regression by
> reverting a
> patch after it was accepted previously.
> >> Sanity checks that trip points only can get lowered (compared to initial
> >> provided ones) needs to be added.
> >> Len, Rui: For short-term can some 
> But I _need_ to raise the unreasonably low passive trip point. We could
> decide to
> protect the innocent user by allowing write access to trip_points only
> after a previous

Actually, you should lower your active trip point, and keep cpu temp
below 50C.

> echo "I know what I am doing" >
> /proc/acpi/thermal_zone/THRM/enable_really_dangerous_options

No... but patch that only permits lowering could be acceptable.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
