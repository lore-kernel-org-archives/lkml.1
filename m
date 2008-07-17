Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYGQPHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYGQPHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758792AbYGQPHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:07:20 -0400
Received: from el-out-1112.google.com ([209.85.162.181]:34974 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758466AbYGQPHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:07:19 -0400
Date: Thu, 17 Jul 2008 09:07:15 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Richard Purdie <rpurdie@rpsys.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717150715.GD31932@secretlab.ca>
References: <20080714164114.GA18784@polina.dev.rtsoft.ru> <dc452eaab83710e7d6f86dcc5d77bdda@kernel.crashing.org> <20080717110730.GA24775@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717110730.GA24775@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 03:07:30PM +0400, Anton Vorontsov wrote:
> On Thu, Jul 17, 2008 at 07:59:03AM +0200, Segher Boessenkool wrote:
> > What would be the parent node of this, btw?
> 
> This is tricky question. Personally I place them inside the gpio
> controller node that is responsible for the LED. But I think placing the
> led nodes at top level would be also fine (maybe with "leds { }" node as
> a parent for all board's LEDs. What would you suggest for a "best
> practice"?

I like this idea (a 'leds' parent node).  They aren't really children
of the GPIO node or any other device/bus in the system.  Putting them
under a dedicated 'leds' node would make them easy to find and would
have the added advantage of making it easier to have a single driver
instance manage the whole lot.

g.

