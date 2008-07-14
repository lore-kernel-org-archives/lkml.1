Return-Path: <linux-kernel-owner+w=401wt.eu-S1757073AbYGNQZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073AbYGNQZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYGNQZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:25:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753949AbYGNQZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:25:05 -0400
Date: Mon, 14 Jul 2008 09:24:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jack Steiner <steiner@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] - GRU virtual -> physical translation
Message-Id: <20080714092451.2c81a472.akpm@linux-foundation.org>
In-Reply-To: <20080714145255.GA23173@sgi.com>
References: <20080709191439.GA7307@sgi.com>
	<20080711121736.18687570.akpm@linux-foundation.org>
	<20080714145255.GA23173@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 09:52:55 -0500 Jack Steiner <steiner@sgi.com> wrote:

> On Fri, Jul 11, 2008 at 12:17:36PM -0700, Andrew Morton wrote:
> > On Wed, 9 Jul 2008 14:14:39 -0500 Jack Steiner <steiner@sgi.com> wrote:
> > 
> > > Open code the equivalent to follow_page(). This eliminates the
> > > requirement for an EXPORT of follow_page().
> > 
> > I'd prefer to export follow_page() - copying-n-pasting just to avoid
> > exporting the darn thing is silly.
> 
> If follow_page() can be EXPORTed, I think that may make the most sense for
> now.

What was Christoph's reason for objecting to the export?

> > 
> > > In addition, the code
> > > is optimized for the specific case that is needed by the GRU and only
> > > supports architectures supported by the GRU (ia64 & x86_64).
> > 
> > Unless you think that this alone justifies the patch?
> 
> No, at least not now. We don't have enough data yet to know if the additional
> performance is worth having an optimized lookup routine. Currently the
> focus is in making the driver functionally correct. Performance optimization
> will be done later when we have a better understanding of the user apps that
> will use the GRU.
> 
> _IF_ we agree to the export, what is the best way to send you the patches.
> Incremental or an entirely new GRU V3 patch with all issues resolved?

Incremental would be preferred, please.
