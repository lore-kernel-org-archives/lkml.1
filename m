Return-Path: <linux-kernel-owner+w=401wt.eu-S1423212AbXEEPm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423212AbXEEPm7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423214AbXEEPm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:42:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47365 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423212AbXEEPm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:42:56 -0400
Date: Sat, 5 May 2007 08:42:50 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dgc@sgi.com,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 2/3] SLUB: Implement targeted reclaim and partial list
 defragmentation
In-Reply-To: <p738xc3wo66.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0705050840570.26574@schroedinger.engr.sgi.com>
References: <20070504221555.642061626@sgi.com> <20070504221708.596112123@sgi.com>
 <p738xc3wo66.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 May 2007, Andi Kleen wrote:

> clameter@sgi.com writes:
> > 
> > NOTE: This patch is for conceptual review. I'd appreciate any feedback
> > especially on the locking approach taken here. It will be critical to
> > resolve the locking issue for this approach to become feasable.
> 
> Do you have any numbers on how this improves dcache reclaim under memory pressure?

How does one measure something like that?

I wanted to first make sure that the thing is sane. If there is a gaping 
race here then I may have to add more code to cover that.

