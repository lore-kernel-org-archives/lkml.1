Return-Path: <linux-kernel-owner+w=401wt.eu-S1759672AbXEJMeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672AbXEJMeY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbXEJMeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:34:17 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:57762 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbXEJMeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:34:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=SYd2bMp/LRzF2qysyIFi3CZjfe1dMusIfh3EDAamv0qndrA1lqIB8h8hPixvMJH2QKDrpTUyVv/EXYcX2Qqetn+tB1aLN2V+tcX//CHL+bWHtGgYHNDPIJ7M3sgmguNND7b8BTe0oclhp7KGHa2KEGoVG4n4zri9RbypvGuFCIY=
Message-ID: <2c0942db0705100534xd4bc77eq76dd728fedc855b9@mail.gmail.com>
Date: Thu, 10 May 2007 05:34:16 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: swap-prefetch: 2.6.22 -mm merge plans
Cc: "Con Kolivas" <kernel@kolivas.org>, "Ingo Molnar" <mingo@elte.hu>,
       "ck list" <ck@vds.kolivas.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <4642C416.3000205@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	 <200705100928.34056.kernel@kolivas.org>
	 <464261B5.6030809@yahoo.com.au>
	 <200705101134.34350.kernel@kolivas.org> <46427BDB.30004@yahoo.com.au>
	 <2c0942db0705092048m38b36e7fo3a7c2c59fe1612b2@mail.gmail.com>
	 <46429801.8030202@yahoo.com.au>
	 <2c0942db0705092252n13a6a79aq39f13fcfae534de2@mail.gmail.com>
	 <4642C416.3000205@yahoo.com.au>
X-Google-Sender-Auth: a83312f85a47e3f4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/07, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Huh? You already stated one version of it above, namely updatedb. But
>
> So a swapping problem with updatedb should be unusual and we'd like to see
> if we can fix it without resorting to prefetching.
>
> I know the theory behind swap prefetching, and I'm not saying it doesn't
> work, so I'll snip the rest of that.

updatedb is only part of the problem. The other part is that the
kernel has an opportunity to preemptively return some of the evicted
working set to RAM before I ask for it. No fancy use-once algorithm is
going to address that, so your solution is provably incomplete for my
problem.

What's so hard to understand about that?
