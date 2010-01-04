Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126Ab0ADVMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab0ADVMg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921Ab0ADVMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:12:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab0ADVMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:12:31 -0500
Date: Mon, 4 Jan 2010 22:12:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] libsrp: fix compile failure
In-Reply-To: <1262625721.2724.158.camel@mulgrave.site>
Message-ID: <alpine.LNX.2.00.1001042206340.2277@pobox.suse.cz>
References: <1262200866.2749.226.camel@mulgrave.site>  <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain>  <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz> <1262625721.2724.158.camel@mulgrave.site>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Stephen to CC ]

On Mon, 4 Jan 2010, James Bottomley wrote:

> Well, the fact that the compile failure wasn't detected before it went 
> upstream should answer that ...
> 
> But to be more specific: linux-next is our integration tree (and also
> the obscure architecture compile tree).  To ensure the best possible
> integration, every tree should be built and tested in linux-next at
> least once before it goes to Linus.  There were originally technical
> reasons why -mm wasn't in ... I just thought they'd been fixed by now.

/me checks ...

Yes, it indeed is that way -- Andew pulls whole linux-next as one of the 
patches into -mm series.

To make linux-next really working the way it is intended to work we need 
to have -mm part of it, as it is used as a last point for a non-trivial 
amount of patches before they enter Linus' tree.

Andrew, why do we have the current setup, and not the other way around?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
