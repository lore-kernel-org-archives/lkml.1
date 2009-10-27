Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZJ0QPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZJ0QPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755882AbZJ0QPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:15:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:7880 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbZJ0QPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:15:12 -0400
X-ExtLoop1: 1
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
From: reinette chatre <reinette.chatre@intel.com>
To: Frans Pop <elendil@planet.nl>
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
In-Reply-To: <200910271210.31014.elendil@planet.nl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <200910152142.02876.elendil@planet.nl>
	 <1255758143.21134.1360.camel@rc-desk>
	 <200910271210.31014.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 27 Oct 2009 09:15:16 -0700
Message-Id: <1256660116.21134.9172.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frans,

On Tue, 2009-10-27 at 04:10 -0700, Frans Pop wrote:
> Sorry for the delay in replying.
> 
> On Saturday 17 October 2009, reinette chatre wrote:
> > Prompted by this thread we are in process of moving allocation to paged
> > skb. This will definitely reduce the allocation size (from order 2 to
> > order 1) and hopefully help with this problem also. Could you please try
> > with the attached two patches? They are based on 2.6.32-rc4.
> 
> Looks very good! With these patches I no longer get any SKB allocation 
> errors, even during the heaviest freezes while gitk is loading. I do still 
> get (long) music skips during the freezes, but that's not unexpected.
> AFAICT the wireless connection is stable.
> 
> Tested on top of current mainline git: v2.6.32-rc5-81-g964fe08.
> 
> Please add, if you feel it's appropriate, my:
> Reported-and-tested-by: Frans Pop <elendil@planet.nl>

Thank you very much for testing these patches so thoroughly. They are
both on their way upstream already so I am not able to add your
signature at this time. Since these are pretty big changes these patches
will be in 2.6.33.

Reinette


