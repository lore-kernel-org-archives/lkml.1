Return-Path: <linux-kernel-owner+w=401wt.eu-S1767270AbXDTVDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767270AbXDTVDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767271AbXDTVDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:03:39 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767270AbXDTVDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:03:38 -0400
Date: Fri, 20 Apr 2007 14:03:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Jakub Jelinek <jakub@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] lazy freeing of memory through MADV_FREE 2/2
Message-Id: <20070420140316.e0155e7d.akpm@linux-foundation.org>
In-Reply-To: <4627DBF0.1080303@redhat.com>
References: <46247427.6000902@redhat.com>
	<4627DBF0.1080303@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 17:15:28 -0400
Rik van Riel <riel@redhat.com> wrote:

> Restore MADV_DONTNEED to its original Linux behaviour.  This is still
> not the same behaviour as POSIX, but applications may be depending on
> the Linux behaviour already. Besides, glibc catches POSIX_MADV_DONTNEED
> and makes sure nothing is done...

OK, we need to flesh this out a lot please.  People often get confused
about what our MADV_DONTNEED behaviour is.  I regularly forget, then look
at the code, then get it wrong.  That's for mainline, let alone older
kernels whose behaviour is gawd-knows-what.

So...  For the changelog (and the manpage) could we please have a full
description of the 2.6.21 behaviour and the 2.6.21-post-rik behaviour (and
the 2.4 behaviour, if it differs at all)?  Also some code comments to
demystify all of this once and for all?

Thanks.
