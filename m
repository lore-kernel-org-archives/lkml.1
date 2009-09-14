Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZINQyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZINQyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZINQyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:54:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbZINQyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:54:36 -0400
Date: Mon, 14 Sep 2009 12:54:35 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alexey Korolev <akorolex@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: HugeTLB: Driver example
Message-ID: <20090914165435.GA21554@infradead.org>
References: <202cde0e0909132230y52b805a4i8792f2e287b01acb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202cde0e0909132230y52b805a4i8792f2e287b01acb@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 05:30:12PM +1200, Alexey Korolev wrote:
> There is an example of simple driver which provides huge pages mapping
> for user level applications. The  procedure for mapping of huge pages
> to userspace by the driver is:
> 
> 1. Create a hugetlb file on vfs mount of hugetlbfs (h_file)

Note that to get your support code included at all you'll need a real
intree driver, not just an example.  That is if VM people are happy with
the general concept.

