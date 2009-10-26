Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZJ0Myj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZJ0Myj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754271AbZJ0Myh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:54:37 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:55498 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZJ0Myg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:54:36 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/5] Candidate fix for increased number of GFP_ATOMIC failures V2
Date: Tue, 27 Oct 2009 00:45:43 +0100
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>, Sven Geggus <lists@fuchsschwanzdomain.de>,
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
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <200910262317.55960.elendil@planet.nl>
In-Reply-To: <200910262317.55960.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910270045.47456.elendil@planet.nl>
X-OriginalArrivalTime: 27 Oct 2009 12:54:40.0327 (UTC) FILETIME=[A5998D70:01CA5704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 October 2009, Frans Pop wrote:
> Detailed test results follow. I've done 2 test runs with each kernel (3
> for the last).

Forgot to mention that each run was after a reboot, so they are not 
interdependant.
