Return-Path: <linux-kernel-owner+w=401wt.eu-S1763154AbXFEGPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763154AbXFEGPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 02:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXFEGPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 02:15:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35185 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbXFEGPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 02:15:35 -0400
Date: Tue, 5 Jun 2007 07:15:22 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       Daniel Hazelton <dhazelton@enter.net>, akpm <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH -mm 0/5] LZO and swap write failure patches for -mm
Message-ID: <20070605061522.GB25760@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Richard Purdie <rpurdie@openedhand.com>,
	Nitin Gupta <nitingupta910@gmail.com>,
	Daniel Hazelton <dhazelton@enter.net>,
	akpm <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Hugh Dickins <hugh@veritas.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	David Woodhouse <dwmw2@infradead.org>
References: <1180971378.6313.72.camel@localhost.localdomain> <200706041214.38017.dhazelton@enter.net> <1180975976.6313.133.camel@localhost.localdomain> <4cefeab80706041126y5f12402cl61b72ec101dd7915@mail.gmail.com> <1180990731.6313.179.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180990731.6313.179.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 09:58:51PM +0100, Richard Purdie wrote:
> On Mon, 2007-06-04 at 23:56 +0530, Nitin Gupta wrote:
> > Yes there might still be problems - that is why I posted as RFC. I got
> > useful comments and the code is improving. Going for such fork might
> > be pain initially but IMHO its worth it. My idea for this 'fork' is
> > not just clean-ups but potential optimizations that such cleanups
> > usually bring along. I do not think there will be major overhauls in
> > such mature de/compression implementations so I believe its okay to go
> > for such 'fork' for sake of cleaner and perhaps faster code.
> 
> If you want to make cleaner and faster code, why not work on LZO
> upstream directly? I'm sure the LZO author would welcome the speedups,
> just as much as the kernel would. 

Because it's author has shown his preference for crappy code.  Can we
please stop this stupid 'upstream' term here?  LZO is first and most
and algorithm.  There is a really crappy reference implementation, but
we should not put that in but rather have a proper implementation targeted
at the linux kernel.  Whether that implementation starts from scratch or
by gradually improving the existing reference implementation doesn't matter.

