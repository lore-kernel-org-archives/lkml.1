Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbZKDAOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbZKDAOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZKDAOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:14:07 -0500
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:53041 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752502AbZKDAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:14:05 -0500
From: Frans Pop <elendil@planet.nl>
To: Michael Guntsche <mike@it-loops.com>
Subject: Re: Page alloc problems with 2.6.32-rc kernels
Date: Wed, 4 Nov 2009 01:14:07 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20091102122010.GA5552@gibson.comsick.at>
In-Reply-To: <20091102122010.GA5552@gibson.comsick.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911040114.08879.elendil@planet.nl>
X-OriginalArrivalTime: 04 Nov 2009 00:14:10.0018 (UTC) FILETIME=[BB1EF420:01CA5CE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a few more CCs.

On Monday 02 November 2009, Michael Guntsche wrote:
> > I have the server running with all with patches applied and it runs
> > without any issues. Since adding patch5 seems to make a difference I
> > will revert 1-4 and only apply patch 5 to see if it work too. I will
> > report back as soon as I have news.
>
> Current status of my tests here. With only patch 5 applied (the revert)
> I am not able to reproduce the problem. Reading through the ml archives
> I noticed that this revert is somewhat controversial since it seems to
> fix other bugs. Is it possible that reverting those fixes just hide the
> bug I am seeing instead of fixing it?

Thanks Michael. That means we now have two cases where reverting the 
congestion_wait() changes from .31-rc3 (8aa7e847d8 + 373c0a7ed3) makes a 
clear and significant difference.

I wonder if more effort could/should be made on this aspect.

Cheers,
FJP
