Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbZKRF1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbZKRF1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 00:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbZKRF1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 00:27:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33400 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZKRF1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 00:27:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] vmscan: Have kswapd sleep for a short interval and double check it should be asleep fix 1
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <20091117103420.GX29804@csn.ul.ie>
References: <2f11576a0911140134u21eafa83t9642bb25ccd953de@mail.gmail.com> <20091117103420.GX29804@csn.ul.ie>
Message-Id: <20091118142111.3E12.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 18 Nov 2009 14:27:18 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When checking if kswapd is sleeping prematurely, all populated zones are
> checked instead of the zones the instance of kswapd is responsible for.
> The counters for kswapd going to sleep prematurely are also named poorly.
> This patch makes kswapd only check its own zones and renames the relevant
> counters.
> 
> This is a fix to the patch
> vmscan-have-kswapd-sleep-for-a-short-interval-and-double-check-it-should-be-asleep.patch
> and is based on top of mmotm-2009-11-13-19-59. It would be preferable if
> Kosaki Motohiro signed off on it as he had comments on the patch but the
> discussion petered out without a solid conclusion.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Looks good to me.
I apologize to bother you by nit for long time.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



