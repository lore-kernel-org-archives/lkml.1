Return-Path: <linux-kernel-owner+w=401wt.eu-S1758153AbYEEINR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153AbYEEINR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 04:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbYEEIMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 04:12:45 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43972 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbYEEIMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 04:12:43 -0400
Date: Mon, 5 May 2008 01:12:39 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 1/5] fix overflow problem of do_try_to_free_page()
Message-ID: <20080505081239.GB22105@us.ibm.com>
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080504215331.8F55.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504215331.8F55.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Operating-System: Linux 2.6.25-mm1-00024-g164d446 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2008 [21:55:57 +0900], KOSAKI Motohiro wrote:
> this patch is not part of reclaim throttle series.
> it is merely hotfixs.
> 
> ---------------------------------------
> "Smarter retry of costly-order allocations" patch series change 
> behaver of do_try_to_free_pages().
> but unfortunately ret variable type unchanged.
> 
> thus, overflow problem is possible.
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Nishanth Aravamudan <nacc@us.ibm.com>

Eep, sorry -- my original version had used -EAGAIN to indicate a special
condition, but this was removed before the final patch. Thanks for the
catch.

Acked-by: Nishanth Aravamudan <nacc@us.ibm.com>

Should go upstream, as well.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
