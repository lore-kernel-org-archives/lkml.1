Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYJVQHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYJVQHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 12:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757047AbYJVQH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 12:07:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47839 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757034AbYJVQHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 12:07:24 -0400
Date: Wed, 22 Oct 2008 11:07:23 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] SGI RTC: add clocksource/clockevent driver and timer bios calls
Message-ID: <20081022160723.GA21448@sgi.com>
References: <20081021211740.GA3936@sgi.com> <20081022063613.GH651@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022063613.GH651@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 08:36:13AM +0200, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > The following patchset provides a driver and bios call framework for
> > synchronized RTC clocksource and clockevents for SGI systems.
> > 
> > With these patches, a module can be installed that registers the system-wide
> > synchronized RTC clocksource and timers as both a clocksource and clockevents
> > device running in high resolution mode.
> > 
> > 
> > [PATCH 1/3] SGI RTC: add clocksource driver
> > [PATCH 2/3] SGI RTC: add bios framework for RTC timer operations
> > [PATCH 3/3] SGI RTC: add RTC system interrupt
> 
> hm, i dont really like the direction of this.
> 
> Why isnt there a native Linux driver offered for this? This isnt about 
> memory discovery or device discovery, where BIOS interaction might be 
> acceptable (and might be unavoidable). This is about hardware interfaces 
> and drivers, and the last thing we want there is BIOSes.

Ingo,

I'm perfectly willing to do this with a native Linux driver.  My reason for doing it the above way was that as the hardware interfaces change, we wouldn't have to be pulling all of those hardware interface changes into the community kernel.

I'll try to get a new patchset submitted for the native driver tomorrow.
