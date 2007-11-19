Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbXKSSFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbXKSSFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 13:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbXKSSE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 13:04:59 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:52187 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbXKSSE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 13:04:58 -0500
Subject: Re: [RFC 5/7] LTTng instrumentation mm
From: Dave Hansen <haveblue@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <20071116143019.GA16082@Krystal>
References: <20071113193349.214098508@polymtl.ca>
	 <20071113194025.150641834@polymtl.ca> <1195160783.7078.203.camel@localhost>
	 <20071115215142.GA7825@Krystal> <1195164977.27759.10.camel@localhost>
	 <20071116143019.GA16082@Krystal>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 10:04:45 -0800
Message-Id: <1195495485.27759.115.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-16 at 09:30 -0500, Mathieu Desnoyers wrote:
> I see that the standard macro to get the kernel address from a pfn is :
> 
> asm-x86/page_32.h:#define pfn_to_kaddr(pfn)      __va((pfn) << PAGE_SHIFT)
> 
> The question might seem trivial, but I wonder how this deals with large
> pages ?

Well, first of all, large pages are a virtual addressing concept.  We're
only talking about physical addresses here.  You still address the
memory the same way no matter if it is composed of large or small pages.
The physical address (and pfn) never change no matter what we do with
the page or how we allocate ir.

-- Dave

