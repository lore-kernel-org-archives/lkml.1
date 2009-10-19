Return-Path: <linux-kernel-owner+w=401wt.eu-S1757465AbZJSUM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465AbZJSUM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757437AbZJSUM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:12:29 -0400
Received: from james.oetiker.ch ([213.144.138.195]:42442 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbZJSUM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:12:28 -0400
Date: Mon, 19 Oct 2009 22:12:31 +0200 (CEST)
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
In-Reply-To: <20091019145954.GH9036@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0910192211230.27123@sebohet.brgvxre.pu>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910190133.33183.elendil@planet.nl> <1255912562.6824.9.camel@penberg-laptop> <200910190444.55867.elendil@planet.nl> <alpine.DEB.2.00.0910191146110.1306@sebohet.brgvxre.pu> <20091019133146.GB9036@csn.ul.ie>
 <alpine.DEB.2.00.0910191538450.8526@sebohet.brgvxre.pu> <20091019140957.GE9036@csn.ul.ie> <alpine.DEB.2.00.0910191613580.8526@sebohet.brgvxre.pu> <20091019145954.GH9036@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Today Mel Gorman wrote:

> >
> > if you can send me a consolidated patch which does apply to
> > 2.6.31.4 I will be glad to try ...
> >
>
> Sure
>
> ==== CUT HERE ====
>
> From 6c0215af3b7c39ef7b8083ea38ca3ad93cd3f51f Mon Sep 17 00:00:00 2001
> From: Mel Gorman <mel@csn.ul.ie>
> Date: Mon, 19 Oct 2009 15:40:43 +0100
> Subject: [PATCH] Kick off kswapd after direct reclaim and revert congestion changes
>
> The following patch is http://lkml.org/lkml/2009/10/16/89 on top of
> 2.6.31.4 as well as patches 373c0a7e and 8aa7e847 reverted.

it seems to help ... the server has been running for 3 hours now
without incident, but then again it is not as active as during the
day, ... will report tomorrow.

cheers
tobi


-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
