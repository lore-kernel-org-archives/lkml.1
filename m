Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbZJWHbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbZJWHbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbZJWHbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:31:42 -0400
Received: from nerdhammel.gnuher.de ([88.198.0.170]:38836 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZJWHbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:31:41 -0400
Date: Fri, 23 Oct 2009 09:31:21 +0200
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
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
Message-ID: <20091023073120.GA16987@geggus.net>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1256221356-26049-1-git-send-email-mel@csn.ul.ie>
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman schrieb am Donnerstag, den 22. Oktober um 16:22 Uhr:

> [No BZ ID] Kernel crash on 2.6.31.x (kcryptd: page allocation failure..)
> 	This apparently is easily reproducible, particular in comparison to
> 	the other reports. The point of greatest interest is that this is
> 	order-0 GFP_ATOMIC failures. Sven, I'm hoping that you in particular
> 	will be able to follow the tests below as you are the most likely
> 	person to have an easily reproducible situation.

I will see what I can do on the weekend. Unfortunately the crash happens on
a somewhat important machine and afterwards the Software-RAID needs a resync
which takes a few hours.

Sven

-- 
"Those who do not understand Unix are condemned to reinvent it, poorly"
(Henry Spencer)

/me is giggls@ircnet, http://sven.gegg.us/ on the Web
