Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbXEIVol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbXEIVol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 17:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbXEIVoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 17:44:11 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:35582 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298AbXEIVoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 17:44:09 -0400
Date: Wed, 9 May 2007 23:44:08 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm2: power_supply_core.c build failure
Message-ID: <20070509214408.GA26995@rhlx01.hs-esslingen.de>
References: <20070509210818.GA7672@rhlx01.hs-esslingen.de> <20070509212742.GA10967@zarina>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509212742.GA10967@zarina>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 01:27:42AM +0400, Anton Vorontsov wrote:
> On Wed, May 09, 2007 at 11:08:20PM +0200, Andreas Mohr wrote:
> > Care to add a #include <linux/workqueue.h> or so? ;)
> > (worked for me when adding to include/linux/power_supply.h)
> > 
> > Ugh, such a pain following ever-outdated and always-broken -mm versions ;)
> > 
> > Andreas Mohr
> 
> http://lkml.org/lkml/2007/5/9/163

Crap, I did grep for a changed_work report but came up empty thus reported it.
Hmm, incomplete LKML mbox here?

> I really do test builds prior commiting them, but headers changed
> recently, and now including workqueue.h should be explicit. Wondering why
> this worked prior, though. ;-)

Right, several header cleanup efforts recently (which is a good thing).

Note to self: always reply to version announce mail when reporting problems...

Andreas Mohr
