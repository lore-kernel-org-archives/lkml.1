Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbXFRCIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbXFRCIt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 22:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbXFRCIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 22:08:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42647 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752883AbXFRCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 22:08:42 -0400
Date: Sun, 17 Jun 2007 19:08:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Matt Mackall <mpm@selenic.com>
cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
In-Reply-To: <20070617050255.GM11166@waste.org>
Message-ID: <Pine.LNX.4.64.0706171907360.26680@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com> <20070614130645.cabdff1b.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
 <20070614143248.736312f8.akpm@linux-foundation.org>
 <1182043500.2743.7.camel@laptopd505.fenrus.org> <20070617050255.GM11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Matt Mackall wrote:

> Is it? Last I looked it had reverted to handing out reverse-contiguous
> pages.

I thought that was fixed? Bill Irwin was working on it.

But the contiguous pages usually only work shortly after boot. After 
awhile memory gets sufficiently scrambled that the coalescing in the I/O 
layer becomes ineffective.
