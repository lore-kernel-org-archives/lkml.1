Return-Path: <linux-kernel-owner+w=401wt.eu-S1761318AbYGRROr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761318AbYGRROr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYGRROi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:14:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756198AbYGRROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:14:38 -0400
Message-ID: <4880CF52.5020406@linux-foundation.org>
Date: Fri, 18 Jul 2008 12:13:54 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Richard Kennedy <richard@rsk.demon.co.uk>
CC: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage of	some
 key caches
References: <1216211371.3122.46.camel@castor.localdomain>	 <487DF5D4.9070101@linux-foundation.org>	 <1216216730.3122.60.camel@castor.localdomain>	 <487DFFBE.5050407@linux-foundation.org>	 <1216375025.3082.7.camel@castor.localdomain>	 <4880A694.1000100@linux-foundation.org>	 <1216392177.3082.27.camel@castor.localdomain>	 <4880AEFE.3060909@linux-foundation.org> <1216394560.3082.32.camel@castor.localdomain>
In-Reply-To: <1216394560.3082.32.camel@castor.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Kennedy wrote:
> On Fri, 2008-07-18 at 09:55 -0500, Christoph Lameter wrote:
>> OK that is now 4215 pages before and 4112 after the patch? Yawn.... So barely any effect?
> 
> Well it's not huge but there's another 100+ pages out of radix_tree,
> too. & I've not inspected the rest of the cache usage.

Can you post these numbers with the slabinfo for the radix tree as well? It may be that there are a lot of sparsely populated slab pages that waste memory.





