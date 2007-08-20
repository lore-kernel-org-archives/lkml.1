Return-Path: <linux-kernel-owner+w=401wt.eu-S1762306AbXHTVRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbXHTVRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751283AbXHTVR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:17:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49626 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751269AbXHTVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:17:28 -0400
Date: Mon, 20 Aug 2007 14:17:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Pavel Machek <pavel@ucw.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 2/9] Use NOMEMALLOC reclaim to allow reclaim if PF_MEMALLOC
 is set
In-Reply-To: <1187644449.5337.48.camel@lappy>
Message-ID: <Pine.LNX.4.64.0708201415260.31167@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com>  <20070814153501.305923060@sgi.com>
 <20070818071035.GA4667@ucw.cz>  <Pine.LNX.4.64.0708201158270.28863@schroedinger.engr.sgi.com>
  <1187641056.5337.32.camel@lappy>  <Pine.LNX.4.64.0708201323590.30053@schroedinger.engr.sgi.com>
 <1187644449.5337.48.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Peter Zijlstra wrote:

> > Its not that different.
> 
> Yes it is, disk based completion does not require memory, network based
> completion requires unbounded memory.

Disk based completion only require no memory if its not on a stack of 
other devices and if the interrupt handles is appropriately shaped. If 
there are multile levels below or there is some sort of complex 
completion handling then this also may require memory.
