Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444Ab0A1BEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0A1BEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754690Ab0A1BEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:04:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52163 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754650Ab0A1BEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:04:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=T3nwnYHTpPh4k8uaWNE9INfR5iKW2zq/sfMocYSIo3Qzvb0ynlWuleDOf8XZlL1Ul
	q8C+29jeGIHRqkeOFPRmQ==
Date: Wed, 27 Jan 2010 17:04:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mark Lord <kernel@teksavvy.com>
cc: Mel Gorman <mel@csn.ul.ie>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.32.5 regression: page allocation failure. order:1, 
In-Reply-To: <4B60C0A7.7090501@teksavvy.com>
Message-ID: <alpine.DEB.2.00.1001271701170.17513@chino.kir.corp.google.com>
References: <4B5FA147.5040802@teksavvy.com> <20100127120820.GB25750@csn.ul.ie> <4B60C0A7.7090501@teksavvy.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, Mark Lord wrote:

> > There was one bug related to MIGRATE_RESERVE that might be affecting
> > you. It reported as impacting swap-orientated workloads but it could
> > easily affect drivers that depend on high-order atomic allocations.
> > Unfortunately, the fix is not signed-off yet but I expect it to make its
> > way towards mainline when it is.
> > 
> > Here is the patch with a slightly-altered changelog. Can you test if it
> > makes a difference please?
> ..
> 
> We don't like to reboot our 24/7 server very often,
> and certainly not for debugging buggy kernels.
> 
> It's rock solid again with 2.6.31.12 on it now.
> 

Is there something specific about the workload that makes it easily 
reproducible?  Are you saying that 2.6.31.12 is "rock solid" because it 
has survived a certain workload that caused these page allocation failures 
with 2.6.32.5, or simply because it has a longer uptime and hasn't shown 
a problem?  It would be very helpful to describe the load so that we can 
attempt to reproduce it locally without a sacrifice to your server.
