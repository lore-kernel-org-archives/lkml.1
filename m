Return-Path: <linux-kernel-owner+w=401wt.eu-S933420AbXBEVPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420AbXBEVPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933436AbXBEVPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:15:11 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:47128 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933420AbXBEVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:15:09 -0500
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
Date: Mon, 5 Feb 2007 22:15:00 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org> <20070205163152.GA2464@elte.hu> <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702052215.01572.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 5. February 2007, Linus Torvalds wrote:
> So thank God for the few selects we have, and we should add a whole lot 
> more!

But "select" is not fine grained enough.

I would like to have "require", "recommend", "suggest" for feature A.

require X
	does not work without X, but X is way down the tree 
	e.g. ext3 and block device or how select currently is intended

recommend X
	it is usable but uncomfortable without X, enabled per default
	e.g. firewalling recommends connection tracking support 
	or NAT recommends all NAT helpers

suggest X
	many people use A together with X, 
	so you might be interested in enabling it, but I disabled it
	per default unless you said "featuritis mode" before.
	e.g. highmem and SMP or a network driver and NAPI.

That is what the Debian/Ubuntu package management does and maybe other too.
And this also gives us new keywords to replace select with, 
so migration is doable :-)

This would also make "EMBEDDED" superflous, because it would just mean 
"disable anything not required". 

And this would enable an individual tree for the users current configuration 
problem instead of a global one.

Regards

Ingo "and tomorrow we change the world" Oeser :-)
