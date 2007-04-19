Return-Path: <linux-kernel-owner+w=401wt.eu-S1767007AbXDSVnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767007AbXDSVnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767015AbXDSVnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:43:37 -0400
Received: from waste.org ([66.93.16.53]:46144 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767007AbXDSVnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:43:37 -0400
Date: Thu, 19 Apr 2007 16:30:13 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>,
       Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@waste.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 20/20] Add apply_to_page_range() which applies a function to a pte range.
Message-ID: <20070419213013.GI11115@waste.org>
References: <20070404191151.009821039@goop.org> <20070404191206.675793431@goop.org> <20070405044133.GE4892@waste.org> <46149CC9.2070903@goop.org> <20070417205652.GM11115@waste.org> <4627C6B9.7000605@goop.org> <20070419195957.GF11115@waste.org> <4627E131.5070801@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627E131.5070801@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 02:37:53PM -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> > Haven't thought a huge amount about that. Perhaps it's best done with
> > the level 3 callback?
> >   
> 
> Level 2, I think, assuming you count the pte pages as level 1.  I think
> it can be dealt with, so long as it correctly skips level 1 callbacks
> for superpages, and does the test after the level 2 callback has returned.

I was counting from the top down.

-- 
Mathematics is the supreme nostalgia of our time.
