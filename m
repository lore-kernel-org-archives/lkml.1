Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbYADQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbYADQjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 11:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYADQjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 11:39:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35175 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752864AbYADQjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 11:39:11 -0500
Date: Fri, 4 Jan 2008 17:39:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch?] s2ram + P4 + tsc = annoyance
Message-ID: <20080104163914.GA27447@elf.ucw.cz>
References: <1198745736.4235.23.camel@homer.simson.net> <1198779574.4425.50.camel@homer.simson.net> <20071230140456.GJ16946@elte.hu> <20071230140815.GA27858@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230140815.GA27858@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-12-30 15:08:15, Ingo Molnar wrote:
> 
> > ok, i prefer this fix a bit more. (we dont want to set last_tsc 
> > outside of the sync_lock - which your initial patch does)
> 
> i've added your patch to x86.git - thanks Mike! (patch below) I think 
> this would be too dangerous for v2.6.24 though - we can put it back into 
> -stable for 2.6.24.1, once it had more testing?

If it is too dangerous for -final, I guess it is bad idea to push it
into -stable.

Plus it does not fix really bad bug.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
