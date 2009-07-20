Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZGTPry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZGTPry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 11:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751099AbZGTPrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 11:47:53 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:50255 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZGTPrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 11:47:53 -0400
Date: Mon, 20 Jul 2009 16:44:30 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, hugh.dickins@tiscali.co.uk, aarcange@redhat.com,
       chrisw@redhat.com, avi@redhat.com, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       nickpiggin@yahoo.com.au, Michael Kerrisk <mtk.manpages@gmail.com>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH 03/10] ksm: define MADV_MERGEABLE and MADV_UNMERGEABLE
Message-ID: <20090720154430.GE16361@linux-mips.org>
References: <1247851850-4298-1-git-send-email-ieidus@redhat.com> <1247851850-4298-2-git-send-email-ieidus@redhat.com> <1247851850-4298-3-git-send-email-ieidus@redhat.com> <1247851850-4298-4-git-send-email-ieidus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247851850-4298-4-git-send-email-ieidus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 08:30:43PM +0300, Izik Eidus wrote:

> From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> The out-of-tree KSM used ioctls on fds cloned from /dev/ksm to register
> a memory area for merging: we prefer now to use an madvise(2) interface.
> 
> This patch just defines MADV_MERGEABLE (to tell KSM it may merge pages
> in this area found identical to pages in other mergeable areas) and
> MADV_UNMERGEABLE (to undo that).
> 
> Most architectures use asm-generic, but alpha, mips, parisc, xtensa
> need their own definitions: included here for mmotm convenience, but
> we'll probably want to split this and feed pieces to arch maintainers.

I think it's ok to keep these patches combined as a single patch; we'd
normally want them to be applied either all or not at all anyway and if
that's all the arch dependencies KSM has then splitting really just
unnecessarily inflates the number of patches.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
