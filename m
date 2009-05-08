Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbZEHOZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbZEHOZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbZEHOZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:25:47 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:56046 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753762AbZEHOZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:25:47 -0400
Date: Fri, 8 May 2009 10:25:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, Elladan <elladan@eskimo.com>,
       Nick Piggin <npiggin@suse.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
 citizen
In-Reply-To: <20090508183427.f313770f.minchan.kim@barrios-desktop>
Message-ID: <alpine.DEB.1.10.0905081022490.23875@qirst.com>
References: <20090430215034.4748e615@riellaptop.surriel.com> <20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> <20090501123541.7983a8ae.akpm@linux-foundation.org> <20090503031539.GC5702@localhost> <1241432635.7620.4732.camel@twins>
 <20090507121101.GB20934@localhost> <20090507151039.GA2413@cmpxchg.org> <20090508030209.GA8892@localhost> <20090508163042.ba4ef116.minchan.kim@barrios-desktop> <20090508080921.GA25411@localhost> <20090508183427.f313770f.minchan.kim@barrios-desktop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Minchan Kim wrote:

> > > Why did you said that "The page_referenced() path will only cover the ""_text_"" section" ?
> > > Could you elaborate please ?
> >
> > I was under the wild assumption that only the _text_ section will be
> > PROT_EXEC mapped.  No?
>
> Yes. I support your idea.

Why do PROT_EXEC mapped segments deserve special treatment? What about the
other memory segments of the process? Essentials like stack, heap and
data segments of the libraries?

