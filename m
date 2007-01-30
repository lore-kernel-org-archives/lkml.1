Return-Path: <linux-kernel-owner+w=401wt.eu-S932842AbXA3BUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842AbXA3BUL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 20:20:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932671AbXA3BUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 20:20:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:31436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842AbXA3BUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 20:20:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=uP5D8lhHhQo1zWCff0UXPMLq85IGBaRVsQ6VL/AZRE78QdGzW6a+PQIxQ4TSMutJ+
	JYaBZ5eR4VAHyhvHpgh5Q==
Date: Mon, 29 Jan 2007 17:19:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <ak@suse.de>
cc: Andrew Morton <akpm@osdl.org>, Rohit Seth <rohitseth@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm 3/5] x86_64: fixed-size remaining fake nodes
In-Reply-To: <Pine.LNX.4.56.0701291032160.26116@hadoop0.corp.google.com>
Message-ID: <Pine.LNX.4.64.0701291718420.21901@chino.kir.corp.google.com>
References: <Pine.LNX.4.64N.0701251332280.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251333470.13206@attu4.cs.washington.edu>
 <Pine.LNX.4.64N.0701251334280.13206@attu4.cs.washington.edu>
 <200701291436.59930.ak@suse.de> <Pine.LNX.4.56.0701291032160.26116@hadoop0.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, David Rientjes wrote:

> On Mon, 29 Jan 2007, Andi Kleen wrote:
> 
> > On Thursday 25 January 2007 22:37, David Rientjes wrote:
> > > Any leftover memory is allocated
> > > to a final node unless the command-line ends with a comma.
> > 
> > That sounds like syntactical vinegar and a nasty trap. Remember 
> > that venus probe that got lost because of a wrong comma.
> > Can you find some nicer syntax for that please? 
> > 
> 

I agree it's not a good idea to prevent the remaining RAM from being 
allocated to an additional node.  It was helpful in testing and the 
gathering of benchmarks for the purpose of memory management, but not for 
real-world cases.  It's been removed.

		David
