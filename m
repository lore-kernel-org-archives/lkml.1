Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbZJTOUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbZJTOUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 10:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZJTOUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 10:20:10 -0400
Received: from james.oetiker.ch ([213.144.138.195]:37382 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZJTOUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:20:09 -0400
Date: Tue, 20 Oct 2009 16:20:12 +0200 (CEST)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Mel Gorman <mel@csn.ul.ie>
cc: Frans Pop <elendil@planet.nl>, Pekka Enberg <penberg@cs.helsinki.fi>,
       David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>, linux-mm@kvack.org,
       jens.axboe@oracle.com
Subject: Re: [Bug #14141] order 2 page allocation failures (generic)
In-Reply-To: <20091020141423.GH11778@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0910201618340.27618@sebohet.brgvxre.pu>
References: <alpine.DEB.2.00.0910191613580.8526@sebohet.brgvxre.pu> <20091019145954.GH9036@csn.ul.ie> <alpine.DEB.2.00.0910192211230.27123@sebohet.brgvxre.pu> <alpine.DEB.2.00.0910192215450.27123@sebohet.brgvxre.pu> <20091020105746.GD11778@csn.ul.ie>
 <alpine.DEB.2.00.0910201338530.27123@sebohet.brgvxre.pu> <20091020125139.GF11778@csn.ul.ie> <alpine.DEB.2.00.0910201456540.27618@sebohet.brgvxre.pu> <20091020133957.GG11778@csn.ul.ie> <alpine.DEB.2.00.0910201545510.27618@sebohet.brgvxre.pu>
 <20091020141423.GH11778@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Today Mel Gorman wrote:

>
> Over the course of a day, how many would you see? By and large, it seems
> that the problem yourself and Frans are similar except his is a lot more
> severe.

yesterday it was 19 for 24 hours, today it is 9 for 16 hours (day
is not done yet).

> Try on top of vanilla 2.6.31.4 first plase and if failures still occur,
> then on top of the previous patch.

ok

> > we are running virtualbox 3.0.8 on this machine, virtualbox is using
> > the physical network interface in bridge mode access the network.
> > Could this have something todo with the problem ?
> >
>
> I do not know for sure. I'm assuming the configuration is the same on
> both kernels so it's unlikely to be the issue.

just to be on the sure side I created a tickt with the virtualbox
people ... http://www.virtualbox.org/ticket/5260

cheers
tobi

-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
