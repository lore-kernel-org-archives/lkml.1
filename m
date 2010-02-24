Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0BXKDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:03:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55383 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756209Ab0BXKDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:03:17 -0500
Date: Wed, 24 Feb 2010 10:03:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Assorted small patches for regulators
Message-ID: <20100224100314.GA18896@rakim.wolfsonmicro.main>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224073342.15964.8863.stgit@localhost.localdomain>
X-Cookie: You can't take damsel here now.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 11:37:39PM -0800, Dmitry Torokhov wrote:

> I happend to peek into drivers/regulator and saw a bunch of small issues, so
> here goes. The patches are against linux-next, compile-tested only since I
> don't have the hardware,

I'm working through these now, but a few general issues:

 - It'd be very much easier to review patches that do one thing at once,
   especially when the patches do things more invasive than just adding
   annotations or changing types.  The random cleanup stuff makes the
   invasive changes much harder to see and review.
 - Frequently your patches include additional changes above those that
   you list in the changelog which again increases the effort require to
   reviwe - things like random whitespace changes and the addition of
   module annotations seem particularly prone to this.
 - Please always use a subject line for your patches which fits the
   style of the subsystem.  You're using "Regulators:" as a prefix when
   pretty much everything else uses "regulator:".
