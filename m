Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbXJOJGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbXJOJGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 05:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbXJOJGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 05:06:04 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:19347 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbXJOJGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 05:06:01 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH resend] ramdisk: fix zeroed ramdisk pages on memory pressure
Date: Mon, 15 Oct 2007 11:05:57 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
References: <200710151028.34407.borntraeger@de.ibm.com> <200710160006.19735.nickpiggin@yahoo.com.au>
In-Reply-To: <200710160006.19735.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710151105.57442.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 15. Oktober 2007 schrieb Nick Piggin:
> On Monday 15 October 2007 18:28, Christian Borntraeger wrote:
> > Andrew, this is a resend of a bugfix patch. Ramdisk seems a bit
> > unmaintained, so decided to sent the patch to you :-).
> > I have CCed Ted, who did work on the code in the 90s. I found no current
> > email address of Chad Page.
> 
> This really needs to be fixed...

I obviously agree ;-)
We have seen this problem happen several times. 

> I can't make up my mind between the approaches to fixing it.
> 
> On one hand, I would actually prefer to really mark the buffers
> dirty (as in: Eric's fix for this problem[*]) than this patch,
> and this seems a bit like a bandaid...

I have never seen these patches, so I cannot comment on them.
> 
> On the other hand, the wound being covered by the bandaid is
> actually the code in the buffer layer that does this latent
> "cleaning" of the page because it sadly doesn't really keep
> track of the pagecache state. But it *still* feels like we
> should be marking the rd page's buffers dirty which should
> avoid this problem anyway.

Yes, that would solve the problem as well. As long as we fix
the problem, I am happy. On the other hand, do you see any
obvious problem with this "bandaid"?

Christian
