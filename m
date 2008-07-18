Return-Path: <linux-kernel-owner+w=401wt.eu-S1757066AbYGRPWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066AbYGRPWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754496AbYGRPWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:22:46 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:2289 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458AbYGRPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:22:46 -0400
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage of
	some key caches
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <4880AEFE.3060909@linux-foundation.org>
References: <1216211371.3122.46.camel@castor.localdomain>
	 <487DF5D4.9070101@linux-foundation.org>
	 <1216216730.3122.60.camel@castor.localdomain>
	 <487DFFBE.5050407@linux-foundation.org>
	 <1216375025.3082.7.camel@castor.localdomain>
	 <4880A694.1000100@linux-foundation.org>
	 <1216392177.3082.27.camel@castor.localdomain>
	 <4880AEFE.3060909@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 16:22:40 +0100
Message-Id: <1216394560.3082.32.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-07-18 at 09:55 -0500, Christoph Lameter wrote:
> OK that is now 4215 pages before and 4112 after the patch? Yawn.... So barely any effect?

Well it's not huge but there's another 100+ pages out of radix_tree,
too. & I've not inspected the rest of the cache usage.

I hope there's nowhere in the kernel wasting large amounts of memory --
that's what userspace is for ;) 


