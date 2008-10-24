Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYJXOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYJXOX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYJXOXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:23:19 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41845 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbYJXOXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:23:19 -0400
Date: Fri, 24 Oct 2008 15:23:15 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Handle space after for_each_* macros gracefully in
	checkpatch
Message-ID: <20081024142315.GA6481@brain>
References: <20081024115010.GA31761@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024115010.GA31761@basil.nowhere.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 01:50:10PM +0200, Andi Kleen wrote:
> Handle space after for_each_* macros gracefully in checkpatch.pl
> 
> Anyone else seeing the irony of checkpatch.pl recommending to 
> use for_each_cpu_mask, but then not actually parsing it
> correctly.
> 
> When you write 
> 
> 	for_each_cpu_mask (...) { 
> 
> it would complain about the space between mask and the open bracket
> because it thinks it's a normal function call.
> 
> Fix this in a generic way. In theory someone could construct
> a normal function that starts with for_each_* and it would
> not warn, but I think that would be uncommon. The alternative
> of listing all macros was tried first, but turned out to 
> be unwieldly.
> 
> I think I covered most of the common ones available, the
> only exceptions are a few oddballs with leading prefix 
> like pnp_for_each* or zorro_for_each.

I am happy with this conceptually.  However when this was suggested
before there was a concensus that that it was not obvious whether this
was meant to be written as a function or a control and nothing was done.

So if people are with you on this, I am happy.

-apw
