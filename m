Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbYCKQsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbYCKQsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 12:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbYCKQsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 12:48:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.226]:10362 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbYCKQsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 12:48:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RJfL7pyKHrbV1MTavKCnXFofrSu3VJPWPi8KFDXNaKP/mMFMT3Jq7FHLuLb1pNkSezoZ1BYyRysMsUgq8meYGdIUl0vBNnQFp9YVZODoUNQMRU29aqEXBbWsRQmYJE0MPLuvwrtwIFAsPxitW/Sl6P80udF02nuWkA3S9cO4/Wo=
Message-ID: <86802c440803110948o2a4e7bd6y583c32eb1741743e@mail.gmail.com>
Date: Tue, 11 Mar 2008 09:48:05 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] mm: make mem_map allocation continuous.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Lameter" <clameter@sgi.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>, "Mel Gorman" <mel@csn.ul.ie>
In-Reply-To: <20080311081410.GA24240@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440803102322i74333718h60de0da329b139c8@mail.gmail.com>
	 <20080311081410.GA24240@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 1:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>
>  * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>  > [PATCH] mm: make mem_map allocation continuous.
>
>  >       usemap = alloc_bootmem_node(NODE_DATA(nid), usemap_size());
>  > +     printk(KERN_INFO "sparse_early_usemap_alloc: usemap = %p size = %ld\n", usemap, usemap_size());
>
>  this should be in a separate patch.

that should be removed or change to KERN_DEBUG.

YH
