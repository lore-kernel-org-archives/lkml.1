Return-Path: <linux-kernel-owner+w=401wt.eu-S1765563AbZDHNMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765563AbZDHNMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764654AbZDHNJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:09:50 -0400
Received: from mga06.intel.com ([134.134.136.21]:35062 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765286AbZDHNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:09:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,344,1235980800"; 
   d="scan'208";a="504669198"
Subject: Re: leds: just ignore invalid GPIOs in leds-gpio
From: Richard Purdie <rpurdie@linux.intel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <200904071751.49507.david-b@pacbell.net>
References: <200904062059.n36Kxlum026774@hera.kernel.org>
	 <alpine.LRH.2.00.0904071359010.23019@vixen.sonytel.be>
	 <200904071751.49507.david-b@pacbell.net>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 14:09:45 +0100
Message-Id: <1239196186.5339.28.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2009-04-07 at 17:51 -0700, David Brownell wrote:
> On Tuesday 07 April 2009, Geert Uytterhoeven wrote:
> > | drivers/leds/leds-gpio.c:85: warning: 'return' with no value, in function
> > | returning non-void
> > 
> > So what should we return here? -ENODEV? -EINVAL? Anything else?
> 
> Success:  0.  The point is to ignore them, not fail!
> 
> 
> See the appended.

Agreed. I wondered about returning ENODEV and then catching it in the
calling functions but that doesn't work out as very clear code. I'll
queue and submit this.

Cheers,

Richard


