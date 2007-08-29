Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXH2QMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXH2QMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757575AbXH2QLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:11:52 -0400
Received: from bender.weihenstephan.org ([62.245.246.226]:60393 "EHLO
	bender.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbXH2QLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:11:51 -0400
X-Greylist: delayed 1712 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2007 12:11:50 EDT
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: speeding up swapoff
Date: Wed, 29 Aug 2007 17:12:35 +0200
User-Agent: KMail/1.9.4
Cc: Daniel Drake <ddrake@brontes3d.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-mm@kvack.org
References: <1188394172.22156.67.camel@localhost> <20070829073040.1ec35176@laptopd505.fenrus.org> <1188398683.22156.77.camel@localhost>
In-Reply-To: <1188398683.22156.77.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291712.35967.juergen127@kreuzholzen.de>
X-cff-SpamScore: 0(/)
X-cff-SpamReport: ----- ----- _SUMMARY_
X-cff-LastScanner: pcre
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 16:44, Daniel Drake wrote:
> On Wed, 2007-08-29 at 07:30 -0700, Arjan van de Ven wrote:
> > > My experiments show that when there is not much free physical memory,
> > > swapoff moves pages out of swap at a rate of approximately 5mb/sec.
> >
> > sounds like about disk speed (at random-seek IO pattern)
>
> We are only using 'standard' seagate SATA disks, but I would have
> thought much more performance (40+ mb/sec) would be reachable.
>
> > before you go there... is this a "real life" problem? Or just a
> > mostly-artificial corner case? (the answer to that obviously is
> > relevant for the 'should we really care' question)
>
> It's more-or-less a real life problem. We have an interactive
> application which, when triggered by the user, performs rendering tasks
> which must operate in real-time. In attempt to secure performance, we
> want to ensure everything is memory resident and that nothing might be
> swapped out during the process. So, we run swapoff at that time.

Did you play with mlock()?

Juergen
