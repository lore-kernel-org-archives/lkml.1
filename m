Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXCTWYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXCTWYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXCTWYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:24:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52478 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752030AbXCTWYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:24:42 -0400
Date: Tue, 20 Mar 2007 23:24:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] swsusp: fix error paths in snapshot_open
Message-ID: <20070320222403.GQ3545@elf.ucw.cz>
References: <200703122214.02657.rjw@sisk.pl> <200703202226.42673.rjw@sisk.pl> <20070320221615.GO3545@elf.ucw.cz> <200703202324.39213.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703202324.39213.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > We forget to increase device_available if there's an error in
> > > snapshot_open(), so the snapshot device cannot be open at all after
> > > snapshot_open() has returned an error.
> > 
> > Actually, this should go to the beggining of series, as it is
> > (non-critical) bugfix.
> 
> Well, yes.
> 
> I've just kept the original order.  OTOH, I don't think it's as urgent as to go
> into 2.6.21 ("been there forever" kind of thing).

No, it is not urgent enough for 2.6.21... But I have secret plan...
trying to push bitmaps+non-bugfixes for swsusp to 2.6.23, and have
swsusp/s2ram stabilize during 2.6.22. Way too much stuff happened in
2.6.21 series.
								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
