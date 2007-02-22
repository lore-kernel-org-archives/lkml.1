Return-Path: <linux-kernel-owner+w=401wt.eu-S965047AbXBVJ4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965047AbXBVJ4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 04:56:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965134AbXBVJ4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 04:56:48 -0500
Received: from tim.rpsys.net ([194.106.48.114]:55312 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047AbXBVJ4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 04:56:47 -0500
Subject: Re: no backlight on radeon after recent kernel "upgrade"s
From: Richard Purdie <rpurdie@rpsys.net>
To: James Simmons <jsimmons@infradead.org>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>,
       Yaroslav Halchenko <kernel@onerussian.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.64.0702220112440.17121@pentafluge.infradead.org>
References: <20070219044616.GC25659@washoe.onerussian.com>
	 <20070219000412.acad13de.akpm@linux-foundation.org>
	 <1171876788.6046.3.camel@localhost.localdomain>
	 <877iub9mu2.fsf@sycorax.lbl.gov>
	 <1172097718.5790.29.camel@localhost.localdomain>
	 <87fy8z6pdd.fsf@sycorax.lbl.gov>
	 <Pine.LNX.4.64.0702220112440.17121@pentafluge.infradead.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 09:56:16 +0000
Message-Id: <1172138176.5837.27.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 01:13 +0000, James Simmons wrote:
> > Richard Purdie <rpurdie@rpsys.net> writes:
> > 
> > > If FB_RADEON_BACKLIGHT wasn't set for 2.6.20, can you try 2.6.21-rc1
> > > with that option disabled?
> > 
> > i don't have my laptop with me but i am pretty sure
> > FB_RADEON_BACKLIGHT wasn't set for 2.6.20 (i think it showed up as a
> > new option when i did make oldconfig). i'll post the difference when i
> > get home tonight and also try disabling it.
> 
> Correct. You need to enable the backlight for the radeon card.

The problem is when that is set, the device doesn't work as they need
the ibm ACPI driver, not the raedon one.

Richard

