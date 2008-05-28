Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYE1U0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYE1U0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYE1UZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:25:53 -0400
Received: from relay1.sgi.com ([192.48.171.29]:56053 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752230AbYE1UZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:25:52 -0400
Date: Wed, 28 May 2008 13:25:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       cooloney@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <483DBA85.2060502@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI>
 <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Pekka Enberg wrote:

> (cc'ing linux-kernel)
> 
> Paul Mundt wrote:
> > I have no idea why you are maintaining the page->index case here, it's
> > completely broken for page cache pages. Unless someone more familiar with
> > the page->index BUG_ON() tests objects, the BUG_ON() there should be
> > removed completely. Neither Christoph nor I were able to work out what the
> > point of the page->index tests were, and no one else has spoken up about
> > them, so it's likely safe to treat them as bogus.
> 
> We use kobjsize() for pointers returned from do_mmap() which is why I kept the
> page->index case. Are we using PageCompound for those as well?

What does do_mmap have to do with page->index?

