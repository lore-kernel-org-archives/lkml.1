Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbYJJS11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbYJJS11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759788AbYJJS1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:27:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848AbYJJS1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:27:17 -0400
Message-ID: <48EF9E6F.5050006@kernel.org>
Date: Fri, 10 Oct 2008 11:26:55 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Dave Jones <davej@redhat.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Update cacheline size on X86_GENERIC
References: <20081009171453.GA15321@redhat.com> <200810101428.23662.nickpiggin@yahoo.com.au>
In-Reply-To: <200810101428.23662.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> I think P4 technically did have 64 byte cachelines, but had some adjacent
> line prefetching. And AFAIK core2 CPUs can do similar prefetching (but
> maybe it's smarter and doesn't cause so much bouncing?).
> 
> Anyway, GENERIC kernel should run well on all architectures, and while
> going too big causes slightly increased structures sometimes, going too
> small could result in horrible bouncing.

Well, GENERIC really is targetted toward the commercial mainstream at 
the time, with the additional caveat that it shouldn't totally suck on 
anything that isn't so obscure it's irrelevant.  It is thus a moving 
target.  1% on TPC doesn't count as "totally suck", especially since by 
now anyone who is running workloads like TPC either will have phased out 
their P4s or they don't care about performance at all.

> Lastly, I think x86 will go to 128 byte lines in the next year or two, so
> maybe at this point we can just keep 128 byte alignment?

"x86" doesn't have a cache line size; a specific implementation will. 
Which particular implementation do you believe is going to 128-byte L1 
cachelines?

	-hpa
