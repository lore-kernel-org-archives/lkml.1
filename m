Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYHKBec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYHKBec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 21:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYHKBeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 21:34:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYHKBeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 21:34:24 -0400
Date: Sun, 10 Aug 2008 21:34:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Stephane Marchesin <marchesin@icps.u-strasbg.fr>,
       Keith Packard <keithp@keithp.com>, John Stoffel <john@stoffel.org>,
       Hugh Dickins <hugh@veritas.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Message-ID: <20080811013413.GB28884@infradead.org>
References: <1217850352.24714.66.camel@koto.keithp.com> <Pine.LNX.4.64.0808041720500.25617@blonde.site> <1217870748.24714.79.camel@koto.keithp.com> <Pine.LNX.4.64.0808041855050.5717@blonde.site> <1217877645.24714.87.camel@koto.keithp.com> <Pine.LNX.4.64.0808042055240.17041@blonde.site> <18583.47633.987143.236236@stoffel.org> <1217910505.24714.152.camel@koto.keithp.com> <6a89f9d50808060920t168d533g5d440b444e7c09fc@mail.gmail.com> <20080806102437.2d5e5d11@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806102437.2d5e5d11@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:24:37AM -0700, Arjan van de Ven wrote:
> the ATI driver guys already have the interface working.
> 
> In addition.. since when is "oh you must also make it work for THAT" a
> requirement? Traditionally, it's up to the second person to make
> generic code work for them (within reason of course, but I'll argue
> that the bar of reasonableness has been met here)

Important difference between code and interfaces.  GEM is adding new
userspace interface, and it's current form rather ugly ones.  We'd
better think about these hard, and make sure they are useful for the
whole usecase and not a limited subset.

