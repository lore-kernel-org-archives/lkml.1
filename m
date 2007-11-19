Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbXKSV0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbXKSV0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbXKSV0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:26:08 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:52896 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbXKSV0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:26:06 -0500
Subject: Re: [PATCH] Cast page_to_pfn to unsigned long in CONFIG_SPARSEMEM
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mbligh@google.com
In-Reply-To: <1195507183.27759.150.camel@localhost>
References: <20071113194025.150641834@polymtl.ca>
	 <1195160783.7078.203.camel@localhost> <20071115215142.GA7825@Krystal>
	 <1195164977.27759.10.camel@localhost> <20071116144742.GA17255@Krystal>
	 <1195495626.27759.119.camel@localhost> <20071119185258.GA998@Krystal>
	 <1195501381.27759.127.camel@localhost> <20071119195257.GA3440@Krystal>
	 <1195502983.27759.134.camel@localhost> <20071119202023.GA5086@Krystal>
	 <20071119130801.bd7b7021.akpm@linux-foundation.org>
	 <1195507183.27759.150.camel@localhost>
Content-Type: text/plain
Date: Mon, 19 Nov 2007 13:26:02 -0800
Message-Id: <1195507562.27759.154.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 13:19 -0800, Dave Hansen wrote:
> On Mon, 2007-11-19 at 13:08 -0800, Andrew Morton wrote:
> > Heaven knows why though - why does __pfn_to_page() even exist?
> Perhaps it can go away with the
> discontig->sparsemem-vmemmap conversion.

In fact, Christoph Lameter's

                           Subject: 
x86_64: Make sparsemem/vmemmap the
default memory model V2
                              Date: 
        Thu, 15 Nov 2007 19:55:11
-0800 (PST)

does remove it.  

-- Dave

