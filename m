Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbXEJGWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbXEJGWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbXEJGVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:21:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbXEJGVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:21:54 -0400
Date: Wed, 9 May 2007 23:21:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Purdie <richard@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] Add LZO1X compression support to the kernel
Message-Id: <20070509232129.371f49d5.akpm@linux-foundation.org>
In-Reply-To: <1178096183.5860.25.camel@localhost.localdomain>
References: <1178096183.5860.25.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2007 09:56:23 +0100 Richard Purdie <richard@openedhand.com> wrote:

> Current thinking is that lzo should get merged directly followed by the
> subsystem parts through their specific trees. It appears this should
> make it onto LKML despite the size so here goes.
> 
> Please keep in mind I haven't reformatted the LZO code itself as if I do
> so, it will make maintenance of it against any changes in LZO itself
> near impossible. In its current form, it should be possible to diff
> against upstream. All the bad formatting is confined to a handful of
> files in lib/lzo/ and the kernel interface should be clean.
> 
> I realise a maze of ifdefs still remain. I've already spent a lot of
> time removing a ton of them and going much further might start to affect
> diffability of the code - I hoping whats there is a good compromise.
> 
> I've asked the LZO author about the comments on lzo_copyright function
> but the code is GPLv2 licensed so is suitable for inclusion in the
> kernel.
> 
> 
> 
> Add LZO1X compression/decompression support to the kernel.
> 
> This is based on the standard userspace lzo library, particularly
> minilzo with the headers much trimmed down and simplified for kernel
> use. Its structured so that it should still diff with the userspace
> version for ease of future updating.

Well that's attractive-looking code.

Why is this needed?  What code plans to use it?

How many buffer overruns are there in it?

