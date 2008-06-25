Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYFYKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYFYKSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 06:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYFYKSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 06:18:38 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33954 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYFYKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 06:18:38 -0400
Subject: Re: [PATCH] leds: make sure led->trigger is valid before calling
	trigger->activate
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080625095046.GB6950@doriath.ww600.siemens.net>
References: <20080619114847.GA13752@doriath.ww600.siemens.net>
	 <20080624140235.ef3f4d52.akpm@linux-foundation.org>
	 <20080625095046.GB6950@doriath.ww600.siemens.net>
Content-Type: text/plain
Date: Wed, 25 Jun 2008 11:18:22 +0100
Message-Id: <1214389102.5211.25.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-06-25 at 13:50 +0400, Dmitry Baryshkov wrote:
> On Tue, Jun 24, 2008 at 02:02:35PM -0700, Andrew Morton wrote:
> > 
> > The changelog tells us what the patch does, but it doesn't tell us
> > why it does it.
> > 
> > This matters.  For a start, there is no way in which I (at least)
> > am able to determine whether this change is needed in 2.6.26 nor
> > in 2.6.25.x.
> 
> I hope this is better. This isn't an 2.6.25.x material. And probably not
> an 2.6.26.
> 
> From 4ce3598c6ce5e6b529a05432b18996a99cc5bf0d Mon Sep 17 00:00:00 2001
> From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Date: Wed, 25 Jun 2008 13:48:07 +0400
> Subject: [PATCH] leds: make sure led->trigger is valid before calling trigger->activate
> 
> This is necessary if one wants to use the led->trigger field during
> trigger activation for a led (e.g. to set up the state of the led).
> No current drivers depend on this.

I seem to remember actively making the code work the way it does when I
originally wrote it, what I can't remember is why I did that :/.

Anyhow, I have no objections to the change and will probably queue it
for the next merge window, its post 2.6.26 material.

Cheers,

Richard



