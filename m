Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbZJNQbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbZJNQbi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 12:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932245AbZJNQbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 12:31:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:17363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756221AbZJNQbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 12:31:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,559,1249282800"; 
   d="scan'208";a="559525105"
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
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Kalle Valo <kalle.valo@iki.fi>
In-Reply-To: <200910141510.11059.elendil@planet.nl>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <200910132238.40867.elendil@planet.nl> <20091014103002.GA5027@csn.ul.ie>
	 <200910141510.11059.elendil@planet.nl>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 09:30:59 -0700
Message-Id: <1255537859.21134.17.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 06:10 -0700, Frans Pop wrote:
> On Wednesday 14 October 2009, Mel Gorman wrote:
> > The majority of the wireless reports have been in 
> > this driver and I think we have the problem commit there. The only other
> > is a firmware loading problem in e100 after resume that fails to make an
> > atomic order-5 fail.
> 
> Not exactly true. Bartlomiej's report was about ipw2200, so there are at 
> least 3 different drivers involved, two wireless and one wired. Besides 
> that one report is related to heavy swap, one to resume and one to driver 
> reload.

Another report arrived today. Please see
http://thread.gmane.org/gmane.linux.kernel.wireless.general/40858 - it
is an order-5 allocation failure during driver reload.

Reinette

