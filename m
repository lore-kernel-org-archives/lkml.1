Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYAQM0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYAQM0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 07:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbYAQM0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 07:26:36 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50104 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYAQM0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 07:26:35 -0500
Date: Thu, 17 Jan 2008 12:26:33 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Ingo Molnar <mingo@elte.hu>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bugreport kernel panic on early stage, with HIGHMEM4G:
Message-ID: <20080117122632.GA14011@csn.ul.ie>
References: <20080107053908.M5584@visp.net.lb> <20080115113947.GA14603@elte.hu> <20080115131340.GA6237@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080115131340.GA6237@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (15/01/08 14:13), Ingo Molnar didst pronounce:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > thanks for the detailed report, i think i know what's going on. Could 
> > you try the patch below, does it fix your problem?
> 
> find below the fix with a more complete changelog and with no debugging 
> printouts.
> 

Looks good and the right thing to do. If you check the equivilant code for
DISCONTIG, it calls pfn_valid() searching for holes so it was expected.

Acked-by: Mel Gorman <mel@csn.ul.ie>

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
