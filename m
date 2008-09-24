Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYIXQGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYIXQGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYIXQGs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:06:48 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53635 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYIXQGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:06:47 -0400
Subject: Re: [PATCH 1/2] Report the pagesize backing a VMA in
	/proc/pid/smaps
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
In-Reply-To: <20080924154120.GA10837@csn.ul.ie>
References: <20080923211140.DC16.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080923194655.GA25542@csn.ul.ie>
	 <20080924210309.8C3B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080924154120.GA10837@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 24 Sep 2008 09:06:35 -0700
Message-Id: <1222272395.15523.3.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 16:41 +0100, Mel Gorman wrote:
> I admit it's ppc64-specific. In the latest patch series, I made this a
> separate patch so that it could be readily dropped again for this reason.
> Maybe an alternative would be to display MMUPageSize *only* where it differs
> from KernelPageSize. Would that be better or similarly confusing?

I would also think that any arch implementing fallback from large to
small pages in a hugetlbfs area (Adam needs to post his patches :) would
also use this.

-- Dave

