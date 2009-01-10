Return-Path: <linux-kernel-owner+w=401wt.eu-S932593AbZAJBBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593AbZAJBBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZAJBA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:00:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213AbZAJBA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:00:56 -0500
Date: Fri, 9 Jan 2009 17:00:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-ide@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jgarzik@pobox.net
Subject: Re: libata: make parallel port scan a per-host opt-in feature
In-Reply-To: <alpine.LFD.2.00.0901091657090.6528@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0901091659180.6528@localhost.localdomain>
References: <20090109161455.08d5a54c@infradead.org> <alpine.LFD.2.00.0901091655530.6528@localhost.localdomain> <alpine.LFD.2.00.0901091657090.6528@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 Jan 2009, Linus Torvalds wrote:
> 
> On Fri, 9 Jan 2009, Linus Torvalds wrote:
> > 
> > On Fri, 9 Jan 2009, Arjan van de Ven wrote:
> > >  
> > > +	if (!hpriv->cap & HOST_CAP_SSS)
> > > +		host->flags |= ATA_HOST_PARALLEL_SCAN;
> > > +
> > 
> > I don't think that does what you think it does.
> 
> And furthermore I'm surprised gcc doesn't warn about it. It would seem to 
> be an obvious thing to warn about. I'll see what a sparse warning would 
> look like.

Heh. sparse already warns:

	warning: dubious: !x & y

although I'm not sure that's necessarily the most readable warning ever.

			Linus
