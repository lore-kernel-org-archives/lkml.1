Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbXISWrI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbXISWrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:47:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXISWq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:46:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48483 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753771AbXISWqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:46:55 -0400
Date: Wed, 19 Sep 2007 15:45:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Anton Altaparmakov <aia21@cam.ac.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       marc.smith@esmail.mcc.edu, Christoph Lameter <clameter@sgi.com>
Subject: Re: VM/VFS bug with large amount of memory and file systems?
Message-Id: <20070919154542.4ed8ea1e.akpm@linux-foundation.org>
In-Reply-To: <46F19ED6.20501@redhat.com>
References: <C2A8AED2-363F-4131-863C-918465C1F4E1@cam.ac.uk>
	<1189850897.21778.301.camel@twins>
	<20070915035228.8b8a7d6d.akpm@linux-foundation.org>
	<13126578-A4F8-43EA-9B0D-A3BCBFB41FEC@cam.ac.uk>
	<20070917163257.331c7605@twins>
	<46EEB532.3060804@redhat.com>
	<20070917131526.e8db80fe.akpm@linux-foundation.org>
	<46EEE7B7.1070206@redhat.com>
	<20070917141127.ab2ae148.akpm@linux-foundation.org>
	<46F19ED6.20501@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007 18:12:38 -0400
Rik van Riel <riel@redhat.com> wrote:

> Andrew Morton wrote:
> > On Mon, 17 Sep 2007 16:46:47 -0400
> > Rik van Riel <riel@redhat.com> wrote:
> 
> >> Is the slab defragmentation code in -mm or upstream already
> >> or can I find it on the mailing list?
> > 
> > Is on lkml and linux-mm: http://lkml.org/lkml/2007/8/31/329
> 
> > I think the whole approach is reasonable.  It's mainly a matter of going
> > through it all with a toothcomb 
> 
> I've spent the last two days combing through the patches.

Thanks.  So would it be appropriate for Christoph to add the
thus-far-undefined reviewed-by tag to the next version?

> Except for the one doubt I had (resolved in email), and
> one function name comment (on patch 18/26)

yeah.  Basic rule: if the reviewer had to ask a question then others will
later ask themselves the same question when reading the code.  So this is a
very good indicator that there is a missing code comment.

> the code looks
> good to me.

Cool.
