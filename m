Return-Path: <linux-kernel-owner+w=401wt.eu-S1760565AbYGQPUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760565AbYGQPUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbYGQPUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:20:09 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:9646 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755814AbYGQPUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:20:08 -0400
Date: Thu, 17 Jul 2008 19:20:06 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Trent Piepho <tpiepho@freescale.com>, Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717152006.GA26120@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1216133032.5345.73.camel@dax.rpnet.com> <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080717150422.GC31932@secretlab.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 09:04:22AM -0600, Grant Likely wrote:
> On Thu, Jul 17, 2008 at 06:13:35PM +0400, Anton Vorontsov wrote:
> > On Thu, Jul 17, 2008 at 06:05:19PM +0400, Anton Vorontsov wrote:
> > [...]
> > > > I think it would be better to have a module that scans the device tree
> > > > for LED nodes and registers a single leds-gpio platform device for the
> > > > whole lot.
> > > > 
> > > > Thoughts?
> > > 
> > > I like the idea, thanks.
> > 
> > Ugh, no. The idea sounds good, but in practice it isn't, since we'll
> > have to handle suspend/resume ops ourselves. When we stick with the
> > device/driver model we're getting all this for free.
> 
> Won't the leds-gpio driver give you suspend/resume support?

Ah. I just wrongly read your message. You're purposing to use gpio
leds platform driver... I think this is doable, yes.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
