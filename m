Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbXHFSc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbXHFSc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 14:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbXHFScS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 14:32:18 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4350 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755632AbXHFScR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 14:32:17 -0400
Date: Mon, 6 Aug 2007 18:32:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Gautam Iyer <gautam@math.stanford.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Increased CPU usage after upgrading to 2.6.21
Message-ID: <20070806183207.GB5761@ucw.cz>
References: <20070718164347.GE9506@math.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718164347.GE9506@math.stanford.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> PS: I'm using the kernel with Gentoo patchset. But I confirmed the above
>     persists with the vanilla kernels.
> 
> PPS: I also played around with the timer frequency, and premption model.
>      Would those make a difference to CPU usage?

Yes. Or rather, it will make accounting more accurate, so that you see
that 1% cpu usage, unlike previous kernels where something still ate
cpu but kernel did not know it.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
