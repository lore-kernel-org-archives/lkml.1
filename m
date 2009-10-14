Return-Path: <linux-kernel-owner+w=401wt.eu-S1760956AbZJNVeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbZJNVeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 17:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756549AbZJNVeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 17:34:09 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:56199 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752790AbZJNVeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 17:34:07 -0400
From: Frans Pop <elendil@planet.nl>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Wed, 14 Oct 2009 23:33:26 +0200
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
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <20091014165051.GE5027@csn.ul.ie> <1255552911.21134.51.camel@rc-desk>
In-Reply-To: <1255552911.21134.51.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910142333.29625.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 21:33:30.0433 (UTC) FILETIME=[F9380310:01CA4D15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 October 2009, reinette chatre wrote:
> We do queue the GFP_KERNEL allocations when there are only a few buffers
> remaining in the queue (8 right now) ...

Are you sure of this? I have zero messages in my logs about allocation 
failures with GFP_KERNEL, but I do have plenty with "Only 0 free buffers 
remaining" with GFP_ATOMIC.

Does that indicate a bug or could they fall under the ratelimit somehow?
Or do I misunderstand the logic?
