Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924Ab0ADWAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0ADWAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:00:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0ADWAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:00:42 -0500
Received: from cantor.suse.de ([195.135.220.2]:59974 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab0ADWAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:00:41 -0500
Date: Mon, 4 Jan 2010 23:00:40 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] libsrp: fix compile failure
In-Reply-To: <20100104133555.d5231884.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.2.00.1001042300160.2277@pobox.suse.cz>
References: <1262200866.2749.226.camel@mulgrave.site> <alpine.LFD.2.00.0912301132260.11961@localhost.localdomain> <alpine.LRH.2.00.1001041619130.15694@twin.jikos.cz> <1262625721.2724.158.camel@mulgrave.site> <alpine.LNX.2.00.1001042206340.2277@pobox.suse.cz>
 <20100104133555.d5231884.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, Andrew Morton wrote:

> > Yes, it indeed is that way -- Andew pulls whole linux-next as one of the 
> > patches into -mm series.
> > 
> > To make linux-next really working the way it is intended to work we need 
> > to have -mm part of it, as it is used as a last point for a non-trivial 
> > amount of patches before they enter Linus' tree.
> > 
> > Andrew, why do we have the current setup, and not the other way around?
> 
> Because I suck.  I haven't yet got around to feeding -mm into 
> linux-next.  It's a bit tricky, because -mm is based on linux-next. 
> Probably we'll address this by adding a "linux-next before the mm bits" 
> marker to linux-next.

Yup. That should work and would be really helpful.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
