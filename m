Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbYGNHnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbYGNHnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYGNHnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:43:08 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:53498 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753505AbYGNHnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:43:07 -0400
X-Greylist: delayed 1914 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 03:43:06 EDT
Subject: Re: [PATCH 1/1] LCD backlight driver using Atmel PWM driver
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080711121752.56db3d83.akpm@linux-foundation.org>
References: <1215608886-26792-1-git-send-email-hans-christian.egtvedt@atmel.com>
	 <20080711121752.56db3d83.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 09:11:02 +0200
Message-Id: <1216019462.7672.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-11 at 12:17 -0700, Andrew Morton wrote:
> On Wed,  9 Jul 2008 15:08:06 +0200 Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com> wrote:
> 
> > +	if (bd->props.power != FB_BLANK_UNBLANK)
> > +		intensity = 0;
> > +	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
> > +		intensity = 0;
> 
> hm, is that correct?  It is strange that two different fields can validly
> be compared with the same enumeration like this.
> 

I also found it a bit weird having two fields indicating the same, but
the header file has the following documentation:

/* Current FB Power mode (0: full on, 1..3: power saving
   modes; 4: full off), see FB_BLANK_XXX */
int power;
/* FB Blanking active? (values as for power) */
int fb_blank;

So, AFAIK, my assumptions are correct to get proper blanking?

-- 
With kind regards,
Hans-Christian Egtvedt, Applications Engineer

