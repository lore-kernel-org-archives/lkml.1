Return-Path: <linux-kernel-owner+w=401wt.eu-S1761155AbZEGLdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761155AbZEGLdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 07:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZEGLdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 07:33:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59394 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZEGLdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 07:33:32 -0400
Date: Thu, 7 May 2009 13:31:20 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>, Izik Eidus <ieidus@redhat.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 3/6] ksm: change the KSM_REMOVE_MEMORY_REGION ioctl.
Message-ID: <20090507113120.GH16078@random.random>
References: <1241475935-21162-2-git-send-email-ieidus@redhat.com> <1241475935-21162-3-git-send-email-ieidus@redhat.com> <1241475935-21162-4-git-send-email-ieidus@redhat.com> <4A00DF9B.1080501@redhat.com> <4A014C7B.9080702@redhat.com> <Pine.LNX.4.64.0905061110470.3519@blonde.anvils> <20090506133434.GX16078@random.random> <4A019719.7030504@redhat.com> <Pine.LNX.4.64.0905061739540.5934@blonde.anvils> <20090506164945.GD15712@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506164945.GD15712@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 09:49:45AM -0700, Chris Wright wrote:
> I like merge.  For madvise() approach I had used:
> 
> +#define MADV_SHAREABLE 12              /* can share identical pages */
> +#define MADV_UNSHAREABLE 13            /* can not share identical pages
> 
> But those are maybe better put as MADV_(UN)MERGEABLE (gets a bit confusing when
> you talk of merging vmas ;-)
> */

What this thing does is to create shared pages by merging equal pages...

While I don't care about the naming much myself, one problem I have is
that I've been writing a KSM paper for linuxsymposium and I'd like to
use a nomenclature that is in sync with how this stuff should be
called on lkml, to avoid confusion.

So should I change the simpler word KSM with "Memory Merging feature"
all over the paper?

In addition I consistently use the term "shared KSM pages" often,
should I rename all those instances to "merged pages"? I used the word
'merging' only when describing the operation KSM does when it creates
shared pages, but never to name the generated pages themself.

Thanks,
Andrea
