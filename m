Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZJ0Mzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZJ0Mzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZJ0Mzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:55:51 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:55547 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752809AbZJ0Myi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:54:38 -0400
From: Frans Pop <elendil@planet.nl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Tue, 27 Oct 2009 12:10:27 +0100
User-Agent: KMail/1.9.9
Cc: Mel Gorman <mel@csn.ul.ie>, David Rientjes <rientjes@google.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910152142.02876.elendil@planet.nl> <1255758143.21134.1360.camel@rc-desk>
In-Reply-To: <1255758143.21134.1360.camel@rc-desk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200910271210.31014.elendil@planet.nl>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2009 12:54:41.0014 (UTC) FILETIME=[A6026160:01CA5704]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in replying.

On Saturday 17 October 2009, reinette chatre wrote:
> Prompted by this thread we are in process of moving allocation to paged
> skb. This will definitely reduce the allocation size (from order 2 to
> order 1) and hopefully help with this problem also. Could you please try
> with the attached two patches? They are based on 2.6.32-rc4.

Looks very good! With these patches I no longer get any SKB allocation 
errors, even during the heaviest freezes while gitk is loading. I do still 
get (long) music skips during the freezes, but that's not unexpected.
AFAICT the wireless connection is stable.

Tested on top of current mainline git: v2.6.32-rc5-81-g964fe08.

Please add, if you feel it's appropriate, my:
Reported-and-tested-by: Frans Pop <elendil@planet.nl>

Cheers,
FJP
