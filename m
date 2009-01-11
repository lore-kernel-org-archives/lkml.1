Return-Path: <linux-kernel-owner+w=401wt.eu-S1754417AbZAKX70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbZAKX70 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 18:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZAKX7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 18:59:18 -0500
Received: from mga12.intel.com ([143.182.124.36]:27992 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbZAKX7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 18:59:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,249,1231142400"; 
   d="scan'208";a="98802042"
Subject: Re: 2.6.29-mmotm0109 Odd prompt for Sharp Corgi backlight.
From: Richard Purdie <rpurdie@linux.intel.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <67095.1231699127@turing-police.cc.vt.edu>
References: <67095.1231699127@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Sun, 11 Jan 2009 23:59:59 +0000
Message-Id: <1231718399.5304.62.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-11 at 13:38 -0500, Valdis.Kletnieks@vt.edu wrote:
> So I'm building mmotm-0109, doing a 'make oldconfig', and out pops:
> 
>     Generic (aka Sharp Corgi) Backlight Driver (BACKLIGHT_GENERIC) [Y/n/m/?] (NEW) ?
> 
> Say y to enable the generic platform backlight driver previously
> known as the Corgi backlight driver. If you have a Sharp Zaurus
> SL-C7xx, SL-Cxx00 or SL-6000x say y.
> 
> 
> Two questions:
> 
> 1) Is it a Corgi driver, or truly a generic one?  It can't be *too* generic
> if it only applies to 3 Sharp Zaurus models?  Or do I want to specify it for
> my Dell laptop that has a backlight too (in which case that help text needs
> fixing)...

It is truly generic code now. Your Dell laptop won't use it but it won't
hurt it either.

> 2) Why does this default to 'Y'? (Probably depends on the answer to (1) - if
> it's for one vendor, it probably should be N, but Y may make sense if it's
> proper for the vast majority of all laptops and similar that have a backlight.

It defaults to Y since its harmless if not used and will become the
common case for a large number of devices.

Cheers,

Richard



