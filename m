Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYE1U3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYE1U3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 16:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYE1U3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 16:29:08 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33634 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753222AbYE1U3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 16:29:05 -0400
Date: Wed, 28 May 2008 13:29:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Paul Mundt <lethal@linux-sh.org>, LKML <linux-kernel@vger.kernel.org>,
       cooloney@kernel.org, akpm@linux-foundation.org, dhowells@redhat.com,
       mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
In-Reply-To: <483DBFC3.1070108@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI>
 <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi>
 <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com>
 <483DBFC3.1070108@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > > We use kobjsize() for pointers returned from do_mmap() which is why I kept
> > > the
> > > page->index case. Are we using PageCompound for those as well?
> > 
> > What does do_mmap have to do with page->index?
> 
> I don't know how the nommu code is supposed to work. I simply assumed it has a
> reason for being there and that compound_order() is not enough to handle that.

Could the nommu people either tell us what this is all about? Or junk the 
code. This looks very wrong.

