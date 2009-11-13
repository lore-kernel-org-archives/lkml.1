Return-Path: <linux-kernel-owner+w=401wt.eu-S1752666AbZKMMrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbZKMMrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 07:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZKMMrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 07:47:33 -0500
Received: from james.oetiker.ch ([213.144.138.195]:40557 "EHLO
	james.oetiker.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbZKMMrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 07:47:32 -0500
Date: Fri, 13 Nov 2009 13:47:35 +0100 (CET)
From: Tobias Oetiker <tobi@oetiker.ch>
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\\\"" <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 0/5] Reduce GFP_ATOMIC allocation failures, candidate
 fix V3
In-Reply-To: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.0911131346560.22447@wbuna.brgvxre.pu>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Yesterday Mel Gorman wrote:

> Sorry for the long delay in posting another version. Testing is extremely
> time-consuming and I wasn't getting to work on this as much as I'd have liked.
>
> Changelog since V2
>   o Dropped the kswapd-quickly-notice-high-order patch. In more detailed
>     testing, it made latencies even worse as kswapd slept more on high-order
>     congestion causing order-0 direct reclaims.
>   o Added changes to how congestion_wait() works
>   o Added a number of new patches altering the behaviour of reclaim

so is there anything promissing for the order 5 allocation problems
in this set?

cheers
tobi


-- 
Tobi Oetiker, OETIKER+PARTNER AG, Aarweg 15 CH-4600 Olten, Switzerland
http://it.oetiker.ch tobi@oetiker.ch ++41 62 775 9902 / sb: -9900
