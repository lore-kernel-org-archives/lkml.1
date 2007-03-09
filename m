Return-Path: <linux-kernel-owner+w=401wt.eu-S1752639AbXCIIbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbXCIIbx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXCIIbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:31:52 -0500
Received: from mx10.go2.pl ([193.17.41.74]:44651 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752639AbXCIIbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:31:52 -0500
Date: Fri, 9 Mar 2007 09:35:54 +0100
From: Jarek Poplawski <jarkao2@o2.pl>
To: Christoph Hellwig <hch@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use more gcc extensions in the Linux headers
Message-ID: <20070309083554.GB1662@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309075245.GD8798@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-03-2007 08:52, Christoph Hellwig wrote:
> On Fri, Mar 09, 2007 at 04:56:32PM +1100, Rusty Russell wrote:
...
>> +#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0])			      \
>> +	+ sizeof(typeof(int[1 - 2*!!__builtin_types_compatible_p(typeof(arr), \
>> +		 typeof(&arr[0]))]))*0)
> 
> This needs a comment explaning why we're doing this, and maybe a little
> explanation of the combination of gcc magic and C trickery used to implement
> it to the brave non-uberhacker people trying to understand linux headers.

...and to deprive them of all the pleasure of contemplating...

Jarek P.
