Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZJWVMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZJWVMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:12:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbZJWVMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:12:41 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45818 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbZJWVMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:12:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JdH+BYM9v+cqkXjMUQ9GbjpwU0isZTZtO9slg6A+gFeHSENPLGotyINRiOBHE9lPBe
         jc/79sFMk2oQRQ0u0LwXeWoJpHtv9UApsTuQBz2Vg2gzbFR2LK9riUSZYqoCACt9eVsr
         V3cAI99IZlXXqRDmTwOFQQ0YuLFdrH37cOcFM=
Date: Fri, 23 Oct 2009 23:12:39 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC
	failures V2
Message-ID: <20091023211239.GA6185@bizet.domek.prywatny>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <20091023165810.GA4588@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091023165810.GA4588@bizet.domek.prywatny>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 06:58:10PM +0200, Karol Lewandowski wrote:
> On Thu, Oct 22, 2009 at 03:22:31PM +0100, Mel Gorman wrote:
> > Test 3: If you are getting allocation failures, try with the following patch
> > 
> >   3/5 vmscan: Force kswapd to take notice faster when high-order watermarks are being hit

> No, problem doesn't go away with these patches (1+2+3).  However, from
> my testing this particular patch makes it way, way harder to trigger
> allocation failures (but these are still present).
> 
> This bothers me - should I test following patches with or without
> above patch?  This patch makes bug harder to find, IMVHO it doesn't
> fix the real problem.
..

> Test 4: If you are still getting failures, apply the following
>  4/5 page allocator: Pre-emptively wake kswapd when high-order watermarks are hit

Ok, I've tested patches 1+2+4 and bug, while very hard to trigger, is
still present. I'll test complete 1-4 patchset as time permits.

Thanks.
