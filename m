Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586Ab0AVAQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab0AVAQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755142Ab0AVAQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:16:55 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35930 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab0AVAQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:16:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC-PATCH 0/7] Memory Compaction v1
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20100121101112.GH5154@csn.ul.ie>
References: <20100121115636.73BA.A69D9226@jp.fujitsu.com> <20100121101112.GH5154@csn.ul.ie>
Message-Id: <20100122091504.6BF7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 22 Jan 2010 09:16:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Comments?
> > 
> > I think "Total pages reclaimed" increasing is not good thing ;)
> 
> First, I made a mistake in the patch. With the bug fixed, they're
> reduced. See the post later in the thread
> http://lkml.org/lkml/2010/1/6/215

Oh, I see. I'm glad the issue was alredy fixed.


> > Honestly, I haven't understand why your patch increase reclaimed and
> > the exactly meaning of the your tool's rclm field.
> > 
> > Can you share your mesurement script? May I run the same test?
> 
> Unfortunately at the moment it's part of a mini-testgrid setup I run out
> of the house. It doesn't lend itself to being stand-alone. I'll break it
> out as part of the next release.

surely good news :)


> > I like this patch, but I don't like increasing reclaim. I'd like to know
> > this patch require any vmscan change and/or its change mitigate the issue.
> > 
> 
> With the bug repaired, reclaims go from 105132 to 45935 with more huge
> pages allocated so right now, no special action is required.

ok. thanks.



