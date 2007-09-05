Return-Path: <linux-kernel-owner+w=401wt.eu-S1756452AbXIEINY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbXIEINY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 04:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755820AbXIEINS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 04:13:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:60399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbXIEINR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 04:13:17 -0400
From: Andi Kleen <ak@suse.de>
To: Mike Travis <travis@sgi.com>
Subject: Re: [PATCH 3/6] x86: Convert cpu_sibling_map to be a per cpu variable (v2) (fwd)
Date: Wed, 5 Sep 2007 09:10:10 +0100
User-Agent: KMail/1.9.1
Cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamalesh@linux.vnet.ibm.com
References: <Pine.LNX.4.64.0708312028400.24049@schroedinger.engr.sgi.com> <20070904141055.e00a60d7.akpm@linux-foundation.org> <46DDE623.1090402@sgi.com>
In-Reply-To: <46DDE623.1090402@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709050910.10954.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > It'd be better to convert the unconverted architectures?

Agreed.

> I can easily do the changes for ia64 and test them.  I don't have the
> capability of testing on the powerpc.

You can get cross compilers and make it compile and I'm sure some
powerpc person will be happy to test it then when you post the patches

> And are you asking for just the changes to fix the build problem, or the
> whole set of the changes that were made for x86_64 and i386 in regards to
> converting NR_CPU arrays to per cpu data?

At least the variables that are used by non architecture specific code 
(like cpu_sibling_map) should be probably all converted. For architecture
specific variables it's ok to leave it to the architecture people.

-Andi
