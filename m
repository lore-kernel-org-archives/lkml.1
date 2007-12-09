Return-Path: <linux-kernel-owner+w=401wt.eu-S1751918AbXLIN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbXLIN7T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXLIN7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:59:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbXLIN7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:59:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52, [2.6.24-rc4-git5: Reported regressions from 2.6.23]
Date: Sun, 9 Dec 2007 15:17:42 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
References: <200712080340.49546.rjw@sisk.pl> <20071208100950.a3547868.akpm@linux-foundation.org> <20071209075807.GB29587@elte.hu>
In-Reply-To: <20071209075807.GB29587@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091517.43669.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 9 of December 2007, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > It's a kmap_atomic() debugging patch which I wrote ages ago and whcih 
> > Ingo sucked into his tree.  I don't _think_ this warning is present in 
> > your tree at all.
> > 
> > http://lkml.org/lkml/2007/11/29/157 is where it starts.
> > 
> > I had a lenghty back-and-forth with Christoph on this within the past 
> > couple of months and I cannot locate the thread and I don't recall 
> > what the upshot was and Christoph is still offline.
> > 
> > Knocking out __GFP_ZERO at the point where the slab allocator(s) call 
> > the page allocator seems like a good approach to me.
> > 
> > But I don't think we need to do anything for 2.6.24..
> 
> ok - Rafael, please strike this off the regressions list, there is no 
> problem in .24 other than the double memset for some SLOB metadata.

OK, dropped.

Thanks,
Rafael
