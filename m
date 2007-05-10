Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbXEJTE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbXEJTE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754627AbXEJTEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:04:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52268 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754326AbXEJTEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:04:52 -0400
Date: Thu, 10 May 2007 12:04:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Heinz Mauelshagen <mauelshagen@redhat.com>
Subject: Re: [2.6.22 PATCH 23/26] dm delay:
In-Reply-To: <20070510120223.bb4c22df.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705101204150.10698@schroedinger.engr.sgi.com>
References: <20070508194859.GD24114@agk.fab.redhat.com>
 <20070508175410.d5b7e91f.akpm@linux-foundation.org>
 <20070510120223.bb4c22df.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007, Andrew Morton wrote:

> > > +	delayed_cache = kmem_cache_create("dm-delay",
> > > +					  sizeof(struct delay_info),
> > > +					  __alignof__(struct delay_info),
> > > +					  0, NULL, NULL);
> > 
> > We have an ugly^Wnice new KMEM_CACHE macro for this now.

How could I nicify the macro? Lower case?
