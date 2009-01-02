Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbZABTze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbZABTze (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 14:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758111AbZABTzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 14:55:20 -0500
Received: from 1wt.eu ([62.212.114.60]:1062 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZABTzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 14:55:19 -0500
Date: Fri, 2 Jan 2009 20:54:17 +0100
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       akpm@linux-foundation.org, rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: Re: [PATCH] kbuild: Disallow GCC 4.1.0 / 4.1.1
Message-ID: <20090102195417.GB5038@1wt.eu>
References: <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102174641.GA27287@elte.hu> <alpine.LFD.2.00.0901020953280.5086@localhost.localdomain> <20090102180110.GA7425@elte.hu> <alpine.LFD.2.00.0901021004440.5086@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901021004440.5086@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:05:47AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Jan 2009, Ingo Molnar wrote:
> > 
> > So what i tried to point out that your patch causes a regression here - 
> > we dont filter out gcc 3.0/3.1 out anymore.
> 
> What I tried to tell you was that we don't care - nobody can have it 
> anyway. If somebody tried to compile the kernel with it, we've already 
> refused for the last 2+ years. So there are no old users out there. And 
> there certainly aren't any new ones.

Yes some people (including me) still have them and are happy that there
is a check to prevent accidental builds with an inappropriate compiler.

Willy

