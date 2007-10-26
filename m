Return-Path: <linux-kernel-owner+w=401wt.eu-S1760592AbXJZXQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760592AbXJZXQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 19:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJZXQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 19:16:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50126 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbXJZXQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 19:16:11 -0400
Date: Fri, 26 Oct 2007 16:14:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Zach Brown <zach.brown@oracle.com>
cc: Karl Schendel <kschendel@datallegro.com>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Leonid Ananiev <leonid.i.ananiev@linux.intel.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Fix bad data from non-direct-io read after direct-io
 write
In-Reply-To: <47227015.6060708@oracle.com>
Message-ID: <alpine.LFD.0.999.0710261611511.30120@woody.linux-foundation.org>
References: <47225835.4050309@datallegro.com>
 <alpine.LFD.0.999.0710261425240.30120@woody.linux-foundation.org>
 <47226A75.1020008@oracle.com> <alpine.LFD.0.999.0710261541410.30120@woody.linux-foundation.org>
 <47227015.6060708@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Zach Brown wrote:
> 
> I can throw together a patch if you haven't already committed one by the
> time you read this ;).

I'm not touching that code except to send out possible patches for others 
to test and comment on. I have no test-cases, nor any real interest in it. 
So yeah, please send me a tested and thought-through patch.

It sounded like Karl actually had a test-case to trigger this, but maybe 
I'm confused (and it sounds a bit unlikely, since it should be hard to 
trigger.. Although maybe you can trigger it by doing a direct_IO write 
with the *source* being an mmap() of the file you're writing to, and 
depending on the write itself re-populating the destination in the page 
cache?)

Karl?

		Linus
