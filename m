Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYCBPnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYCBPnF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 10:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbYCBPmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 10:42:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2354 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752440AbYCBPmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 10:42:53 -0500
Date: Sun, 2 Mar 2008 11:40:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: huggie@earth.li, linux-kernel@vger.kernel.org
Subject: Re: Scheduler broken? sdhci issues with scheduling
Message-ID: <20080302104031.GB3861@ucw.cz>
References: <20080229115256.GG24533@paranoidfreak.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229115256.GG24533@paranoidfreak.co.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-02-29 11:52:57, Simon Huggins wrote:
> [ Please Cc me on replies ]
> 
> I had a bug with sdhci which Pierre Ossman looked at for me.
> 
> In the end essentially the fix was to use HZ=1000 and nothing else.
> Pierre seemed to think that this was a bug in the scheduler.
> 
> I'm interested if someone who groks the scheduler could take a look at
> the mmc/* code and see if it's abusing HZ or if there's anything
> obviously wrong there.  If it's not then perhaps there really is a bug
> in the scheduler?

Is mmc slow or does it just break down? Slow would be expected, but
breaking down should be fixed in MMC, too...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
