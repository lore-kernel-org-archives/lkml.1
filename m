Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYJIRU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYJIRU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbYJIRUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:20:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:50686 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754503AbYJIRUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:20:19 -0400
Date: Thu, 9 Oct 2008 19:20:09 +0200
From: Pavel Machek <pavel@suse.cz>
To: Chris Snook <csnook@redhat.com>
Cc: Jeff Hansen <x@jeffhansen.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: x86_32 tsc/pit and hrtimers
Message-ID: <20081009172009.GD1370@ucw.cz>
References: <Pine.LNX.4.64.0810071640110.25661@ren> <48ECFEDC.90305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ECFEDC.90305@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Can you please tell me if this is supposed to work, and I just have a
>> poorly configured kernel; or if TSC/PIT drivers were not designed to work
>> this way in the first place.  If it wasn't designed to do this, do you
>> have any tips on implementing this, since I'll be needing to do that?
>>
> This is not supposed to work, but it might be worthwhile to add a boot 
> option to force the kernel to trust the TSC, as hardware that lacks any 
> high-res timers also tends to be primitive enough that the TSC can be 
> trusted, if it exists.  If you patch out the CLOCK_SOURCE_MUST_VERIFY 
> flag on the TSC, do you get correctly-functioning high-res timers on this 
> system?

Untrue. Unstable tsc dates back to pentium MMX times.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
