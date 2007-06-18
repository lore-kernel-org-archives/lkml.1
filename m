Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbXFREtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbXFREtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbXFREti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:49:38 -0400
Received: from holomorphy.com ([66.93.40.71]:42709 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752514AbXFREti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:49:38 -0400
Date: Sun, 17 Jun 2007 21:50:45 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matt Mackall <mpm@selenic.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large Blocksize support
Message-ID: <20070618045045.GH6909@holomorphy.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org> <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com> <20070614143248.736312f8.akpm@linux-foundation.org> <1182043500.2743.7.camel@laptopd505.fenrus.org> <20070617050255.GM11166@waste.org> <Pine.LNX.4.64.0706171907360.26680@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706171907360.26680@schroedinger.engr.sgi.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Matt Mackall wrote:
>> Is it? Last I looked it had reverted to handing out reverse-contiguous
>> pages.

On Sun, Jun 17, 2007 at 07:08:41PM -0700, Christoph Lameter wrote:
> I thought that was fixed? Bill Irwin was working on it.
> But the contiguous pages usually only work shortly after boot. After 
> awhile memory gets sufficiently scrambled that the coalescing in the I/O 
> layer becomes ineffective.

It fell off the bottom of my priority queue, sorry.


-- wli
