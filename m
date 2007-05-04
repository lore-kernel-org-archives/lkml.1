Return-Path: <linux-kernel-owner+w=401wt.eu-S1767614AbXEDGOM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767614AbXEDGOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 02:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767611AbXEDGOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 02:14:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:33548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767614AbXEDGOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 02:14:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=gMygaWr3nz9HSuUMvCVYherMJvrs4dE029qMwVn7wfwtwebZdQi8Q7PARe3e0yVk5
	taG6fI35HQLzyI/NPf5+A==
Message-ID: <b040c32a0705032313m41d53d79tb78828dbe82747aa@mail.gmail.com>
Date: Thu, 3 May 2007 23:13:57 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added to -mm tree
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agl@us.ibm.com, hermes@gibson.dropbear.id.au, wli@holomorphy.com,
       clameter@sgi.com
In-Reply-To: <20070503225832.972057ef.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
	 <20070503183821.b75e8f57.pj@sgi.com>
	 <b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
	 <20070503220331.8fd70ca5.akpm@linux-foundation.org>
	 <20070503225832.972057ef.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/07, Paul Jackson <pj@sgi.com> wrote:
> Note, Ken, that if we did that, the calculation of these new Total and
> Free stats would be a little different than your new code.  Instead of
> looping over the memory nodes in the current tasks mems_allowed mask,
> we would loop over the memory nodes allowed in the cpuset being queried
> (the cpuset whose 'hugepages_total' or 'hugepages_free' special
> file we were reading, not the current tasks cpuset.)

This is even more controversial and messy.  akpm already dropped the
patch and expressed that he doesn't like it.  And I won't go down
another messy path. I will let this idea RIP.
