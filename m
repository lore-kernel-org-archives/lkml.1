Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbXJDTeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbXJDTeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 15:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJDTeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 15:34:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52003 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752018AbXJDTeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 15:34:08 -0400
Date: Thu, 4 Oct 2007 12:34:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: arjan@infradead.org, akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, ak@suse.de, travis@sgi.com
Subject: Re: [14/18] Configure stack size
In-Reply-To: <20071003.214306.41634525.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0710041231590.12221@schroedinger.engr.sgi.com>
References: <20071004035935.042951211@sgi.com> <20071004040004.936534357@sgi.com>
 <20071003213631.7a047dde@laptopd505.fenrus.org> <20071003.214306.41634525.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Oct 2007, David Miller wrote:

> > there is still code that does DMA from and to the stack....
> > how would this work with virtual allocated stack?
> 
> That's a bug and must be fixed.
> 
> There honestly shouldn't be that many examples around.
> 
> FWIW, there are platforms using a virtually allocated kernel stack
> already.

There would be a way to address this by checking in the DMA layer for a 
virtually mapped page and then segmenting I/O at the page boundaries to 
the individual pages. We may need that anyways for large block sizes.



