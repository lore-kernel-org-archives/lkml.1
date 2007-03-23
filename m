Return-Path: <linux-kernel-owner+w=401wt.eu-S934326AbXCWWEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934326AbXCWWEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 18:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934327AbXCWWEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 18:04:47 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49080 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934326AbXCWWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 18:04:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=AS/QjuXBE048i49CLdmOXtlbeLk1s+NmWRcvC5HCLBEMzYLhnHp0aER4FrUbjsGIb
	q2YZBKUxMAxJJKq5frdiw==
Message-ID: <b040c32a0703231504n1bc68dfblaebcd210b079f89b@mail.gmail.com>
Date: Fri, 23 Mar 2007 15:04:33 -0700
From: "Ken Chen" <kenchen@google.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Subject: Re: [patch] rfc: introduce /dev/hugetlb
Cc: "Mel Gorman" <mel@csn.ul.ie>, "Adam Litke" <agl@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
In-Reply-To: <20070323153006.GW2986@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b040c32a0703230144r635d7902g2c36ecd7f412be31@mail.gmail.com>
	 <Pine.LNX.4.64.0703231457360.4133@skynet.skynet.ie>
	 <20070323150924.GV2986@holomorphy.com>
	 <Pine.LNX.4.64.0703231514370.4133@skynet.skynet.ie>
	 <20070323153006.GW2986@holomorphy.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/07, William Lee Irwin III <wli@holomorphy.com> wrote:
> On Fri, 23 Mar 2007, William Lee Irwin III wrote:
> >> Lack of compiletesting beyond x86-64 in all probability.
>
> On Fri, Mar 23, 2007 at 03:15:55PM +0000, Mel Gorman wrote:
> > Ok, this will go kablamo on Power then even if it compiles. I don't
> > consider it a fundamental problem though. For the purposes of an RFC, it's
> > grand and something that can be worked with.
>
> He needs to un-#ifdef the prototype (which he already does), but he
> needs to leave the definition under #ifdef while removing the static
> qualifier. A relatively minor fixup.

Yes, sorry about that for lack of access to non-x86-64 machines.  I
needed to move the function prototype to hugetlb.h and evidently
removed the #ifdef by mistake.  I'm not going to touch this in my next
clean up patch, instead I will just declare char specific
file_operations struct in hugetlbfs and then have char device
reference it.

But nevertheless, hugetlb_get_unmapped_area function prototype  better
be in a header file somewhere.

- Ken
