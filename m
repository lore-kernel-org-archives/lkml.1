Return-Path: <linux-kernel-owner+w=401wt.eu-S1758184AbXFLFfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184AbXFLFfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754526AbXFLFfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:35:10 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:16251 "EHLO
	asav03.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbXFLFfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:35:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYmAOjMbUZKhRO4UGdsb2JhbACHM4gMAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: "Zephaniah E. Hull" <warp@aehallh.com>
Subject: Re: [PATCH] Input: Support for a less exclusive grab.
Date: Tue, 12 Jun 2007 01:35:05 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070609084800.GR6362@aehallh.com> <200706120120.00494.dtor@insightbb.com> <20070612052316.GX6362@aehallh.com>
In-Reply-To: <20070612052316.GX6362@aehallh.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120135.06428.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 01:23, Zephaniah E. Hull wrote:
> On Tue, Jun 12, 2007 at 01:19:59AM -0400, Dmitry Torokhov wrote:
> > 
> > Like I said I would love if xf86-input-evdev did not grab the
> > device at all.
> 
> We have to disable the legacy input handlers somehow, not doing so
> simply isn't an option.

I do not follow. If user's xorg.conf does not use /dev/input/mice and
does not use "kbd" driver then grabbing is not required, is it? Now,
as far as I understand, lack of hotplug support in X is the main
obstacle for removing "mouse" and "kbd" drivers, correct?
 
> > 
> > But rfkill-input is not a legacy handler. My objection is that with your
> > solution you still will rob handlers such rfkill-input of events.
> 
> Urgh.
> 
> So, any thoughts on how to identify legacy input handlers in the input
> system?

I guess keyboard and mousedev will have to be flagged as such in kernel.

-- 
Dmitry
