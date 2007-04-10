Return-Path: <linux-kernel-owner+w=401wt.eu-S1030278AbXDJBHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030278AbXDJBHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 21:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030258AbXDJBHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 21:07:20 -0400
Received: from holomorphy.com ([66.93.40.71]:46497 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030274AbXDJBHT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 21:07:19 -0400
Date: Mon, 9 Apr 2007 18:07:31 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, drfickle@us.ibm.com
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070410010731.GB2986@holomorphy.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070410005054.GA4027@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410005054.GA4027@us.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 05:50:54PM -0700, Nishanth Aravamudan wrote:
>  static int hugetlbfs_set_page_dirty(struct page *page)
>  {
> -	struct page *head = (struct page *)page_private(page);
> +	struct page *head = compound_head(page);

Thanks for cleaning this up.


-- wli
