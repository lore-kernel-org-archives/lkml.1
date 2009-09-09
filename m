Return-Path: <linux-kernel-owner+w=401wt.eu-S1752680AbZIIJia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbZIIJia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZIIJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:38:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58753 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751785AbZIIJi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:38:28 -0400
Date: Wed, 9 Sep 2009 10:38:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] leds: Add WM831x status LED driver
Message-ID: <20090909093830.GA21951@rakim.wolfsonmicro.main>
References: <1252156161-10062-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1252156161-10062-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20090907132212.GA1739@ucw.cz>
 <1252331484.17852.50.camel@dax.rpnet.com>
 <20090909091239.GA4292@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909091239.GA4292@sortiz.org>
X-Cookie: If rash develops, discontinue use.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 09, 2009 at 11:12:42AM +0200, Samuel Ortiz wrote:

> Unless you're basing your tree on linux-next, you may have issues applying
> this patch since the wm831x header is not in Linus tree yet.
> If you have troubles with this patch, let me know and I'll queue it.

It's fine, all the leaf drivers depend on the core driver (they need to
anyway) so Kconfig won't try to build them until the core driver has
been merged.
