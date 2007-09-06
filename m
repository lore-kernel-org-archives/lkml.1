Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbXIFKmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbXIFKmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbXIFKmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:42:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34257 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745AbXIFKmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:42:42 -0400
Date: Thu, 6 Sep 2007 03:38:22 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       planetccrma@ccrma.Stanford.EDU
Subject: Re: 2.6.22.6 + rt9: suspend/hibernate not working
Message-ID: <20070906033822.GA6940@ucw.cz>
References: <1188951154.26511.90.camel@cmn3.stanford.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188951154.26511.90.camel@cmn3.stanford.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Hi Ingo... I'm getting reports from some of my Planet CCRMA users (which
> I confirmed) that the latest rt kernel I released has broken suspend
> (tested on fc6 & fc7, stock Fedora kernel works fine - the rt
> configuration files are virtual clones as far as possible of the
> standard Fedora kernel config files). 
> 
> I don't know where to start debugging this. When suspend is initiated it
> freezes with a "Stopping tasks ... " message in the text console - a
> hard power cycle is the only way to get the machine back to normal.

It should print what went wrong about ~20 seconds. If it does not,
verify that timers work properly for you.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
