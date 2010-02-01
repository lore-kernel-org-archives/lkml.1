Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0BANsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 08:48:35 -0500
Received: from THUNK.ORG ([69.25.196.29]:44192 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0BANse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 08:48:34 -0500
Date: Mon, 1 Feb 2010 08:47:39 -0500
From: tytso@mit.edu
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Dave Chinner <david@fromorbit.com>, Miklos Szeredi <miklos@szeredi.hu>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Christoph Lameter <clameter@sgi.com>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Subject: Re: inodes: Support generic defragmentation
Message-ID: <20100201134739.GA4635@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andi Kleen <andi@firstfloor.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@ftp.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, akpm@linux-foundation.org,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org
References: <20100129204931.789743493@quilx.com>
 <20100129205004.405949705@quilx.com>
 <20100130192623.GE788@thunk.org>
 <20100131083409.GF29555@one.firstfloor.org>
 <20100131210207.GA27883@thunk.org>
 <20100201101702.GH29555@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201101702.GH29555@one.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 11:17:02AM +0100, Andi Kleen wrote:
> 
> On the other hand I would like to keep the option to be more aggressive
> for soft page offlining where it's useful and nobody cares about 
> the cost.

I'm not sure I understand what the goals are for "soft page
offlining".  Can you say a bit more about that?

> Or the "let's add a updatedb" hint approach has the problem that
> it won't cover a lot of other programs (as Linus always points out
> these new interfaces rarely actually get used)

Sure, but the number of programs that scan all of the files in a file
system and would need this sort of hint are actually pretty small.
Uptdatedb and backup programs are pretty much about it.

	      	     	      	  	      - Ted
