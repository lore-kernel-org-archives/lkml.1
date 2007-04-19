Return-Path: <linux-kernel-owner+w=401wt.eu-S1767014AbXDSUNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767014AbXDSUNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767018AbXDSUNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:13:16 -0400
Received: from waste.org ([66.93.16.53]:39384 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767014AbXDSUNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:13:15 -0400
Date: Thu, 19 Apr 2007 14:59:57 -0500
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
Message-ID: <20070419195957.GF11115@waste.org>
References: <20070404191151.009821039@goop.org> <20070404191206.675793431@goop.org> <20070405044133.GE4892@waste.org> <46149CC9.2070903@goop.org> <20070417205652.GM11115@waste.org> <4627C6B9.7000605@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4627C6B9.7000605@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 12:44:57PM -0700, Jeremy Fitzhardinge wrote:
> Matt Mackall wrote:
> > I think adding a flags field and an allocate flag to my callback
> > struct would be sufficient here.
> >   
> 
> Yes, probably.
> 
> What about something that wants to shatter superpages?

Haven't thought a huge amount about that. Perhaps it's best done with
the level 3 callback?

> Don't know that that's a huge concern.  The typedef namespace (*_t) is
> pretty empty, and its not like we're talking about something that's
> visible outside the kernel.  And the syntax is *really* ugly.

Don't really care about this much.

-- 
Mathematics is the supreme nostalgia of our time.
