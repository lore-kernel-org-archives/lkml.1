Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYGQPEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYGQPEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYGQPEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:04:31 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:42075 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYGQPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:04:30 -0400
Date: Thu, 17 Jul 2008 09:04:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Trent Piepho <tpiepho@freescale.com>, Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
Message-ID: <20080717150422.GC31932@secretlab.ca>
References: <1216133032.5345.73.camel@dax.rpnet.com> <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp> <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru> <20080717141335.GA2219@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717141335.GA2219@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 06:13:35PM +0400, Anton Vorontsov wrote:
> On Thu, Jul 17, 2008 at 06:05:19PM +0400, Anton Vorontsov wrote:
> [...]
> > > I think it would be better to have a module that scans the device tree
> > > for LED nodes and registers a single leds-gpio platform device for the
> > > whole lot.
> > > 
> > > Thoughts?
> > 
> > I like the idea, thanks.
> 
> Ugh, no. The idea sounds good, but in practice it isn't, since we'll
> have to handle suspend/resume ops ourselves. When we stick with the
> device/driver model we're getting all this for free.

Won't the leds-gpio driver give you suspend/resume support?

g.

