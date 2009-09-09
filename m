Return-Path: <linux-kernel-owner+w=401wt.eu-S1751609AbZIIJuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbZIIJuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbZIIJuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:50:35 -0400
Received: from mga07.intel.com ([143.182.124.22]:33155 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750932AbZIIJue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:50:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="185632453"
Date: Wed, 9 Sep 2009 11:52:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
Message-ID: <20090909095234.GD4292@sortiz.org>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090907132212.GA1739@ucw.cz>
 <1252331484.17852.50.camel@dax.rpnet.com>
 <20090909091239.GA4292@sortiz.org>
 <20090909093830.GA21951@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909093830.GA21951@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 10:38:30AM +0100, Mark Brown wrote:
> On Wed, Sep 09, 2009 at 11:12:42AM +0200, Samuel Ortiz wrote:
> 
> > Unless you're basing your tree on linux-next, you may have issues applying
> > this patch since the wm831x header is not in Linus tree yet.
> > If you have troubles with this patch, let me know and I'll queue it.
> 
> It's fine, all the leaf drivers depend on the core driver (they need to
> anyway) so Kconfig won't try to build them until the core driver has
> been merged.
I was thinking about actually being able to apply the patch, but this patch is
creating status.h so it should be all fine, yes.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
