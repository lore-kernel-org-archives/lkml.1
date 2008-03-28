Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYC1LBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYC1LBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 07:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbYC1LAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 07:00:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56248 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYC1LAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 07:00:49 -0400
Date: Fri, 28 Mar 2008 12:01:27 +0100
From: Pavel Machek <pavel@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
Subject: Re: 2.6.25-rc7: Ugh.
Message-ID: <20080328110127.GA1706@elf.ucw.cz>
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu> <200803280249.42193.david-b@pacbell.net> <20080328102010.GA633@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328102010.GA633@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-03-28 11:20:10, Ingo Molnar wrote:
> 
> * David Brownell <david-b@pacbell.net> wrote:
> 
> > Prevent the most significant RTC configuration problems:
> > 
> >  - If the new RTC framework is enabled, don't allow any of the
> >    legacy drivers to be configured.
> 
> yay!!!!
> 
> >  - When using generic RTC on x86, enable rtc-cmos by default.
> 
> Amen.
> 
> > It seems too many people are used to enabling a legacy RTC despite the 
> > Kconfig help/comments; the gentle approach hasn't worked.
> 
> Very-Much-Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Pavel Machek <pavel@suse.cz>


> it's not just about being gentle: it's that there are thousands of 
> .config options that are confusing to most users, so our defaults and 
> rules must make sense. If we think that an approach is superior (which 
> your new RTC code certainly is), we have to take up the responsibility 
> of pushing that as a prominent, default choice and excluding the old 
> code. That ends up benefiting everyone, reduces complexity of the 
> kernel. You wont see anyone shed tears for the old code.

...as I got bitten by this, too.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
