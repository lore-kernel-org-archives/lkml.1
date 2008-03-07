Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYCGRww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYCGRww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbYCGRwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:52:44 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:36609 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128AbYCGRwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:52:44 -0500
Date: Fri, 7 Mar 2008 09:51:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-Id: <20080307095152.93a8d1ca.randy.dunlap@oracle.com>
In-Reply-To: <20080307174316.GJ7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307090716.9D3E91B419C@basil.firstfloor.org>
	<20080307090517.b6b27987.randy.dunlap@oracle.com>
	<20080307173146.GI7365@one.firstfloor.org>
	<47D17C4E.9000302@oracle.com>
	<20080307174316.GJ7365@one.firstfloor.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Mar 2008 18:43:16 +0100 Andi Kleen wrote:

> On Fri, Mar 07, 2008 at 09:33:02AM -0800, Randy Dunlap wrote:
> > Andi Kleen wrote:
> > >>>+	maskzone=size[MG] Set size of maskable DMA zone to size.
> > >>>+		 force	Always allocate from the mask zone (for testing)
> > >>                 ^^^^^^^^^^^^^ ??
> > >
> > >What is your question?
> > 
> > That line seems odd.  Is it correct?
> > Why 2 spaces between force and Always?  Why is Always capitalized?
> > Could one of those words be dropped?  They seem a bit redundant.
> 
> The option is either maskzone=size[MG] or maskzone=force
> Each followed with a sentence describing them.

Oh.  I see.

> I tried to make this clear by lining them up, but apparently failed.
> You have a preferred way to formatting such multiple choice options?

I don't know that we have a certain/fixed way for that.

How about:

	maskzone=
		Format: {size[MG] | force}
		size -- Set size of maskable DMA zone to size
		force -- Always allocate from the mask zone (for testing)


---
~Randy
