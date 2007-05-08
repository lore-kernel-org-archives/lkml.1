Return-Path: <linux-kernel-owner+w=401wt.eu-S1031464AbXEHW3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031464AbXEHW3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934857AbXEHW3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:29:30 -0400
Received: from gw.goop.org ([64.81.55.164]:57200 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934777AbXEHW33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:29:29 -0400
Message-ID: <4640F9C4.8050804@goop.org>
Date: Tue, 08 May 2007 15:29:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC/PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com> <20070430235642.e576e917.akpm@linux-foundation.org> <20070508121404.17bd97a6.randy.dunlap@oracle.com> <alpine.DEB.0.99.0705081217180.12908@chino.kir.corp.google.com> <4640E98B.4030107@goop.org> <alpine.DEB.0.99.0705081423500.24138@chino.kir.corp.google.com> <4640ED7D.708@goop.org> <alpine.DEB.0.99.0705081453350.25466@chino.kir.corp.google.com> <4640F3FD.80001@goop.org> <alpine.DEB.0.99.0705081510370.25865@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.0.99.0705081510370.25865@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> It is analogous with a sequence point for ia64.  But, as you mentioned, it 
> is ia64 specific so your comment about "asm volatile" constructs not being 
> reordered is always appropriate outside of ia64 specific code but may not 
> apply to ia64 if we ever compiled with -mvolatile-asm-stop.  If we do not
> compile with that option, the behavior is unspecified.  I don't think 
> we'll be adding -mvolatile-asm-stop support any time soon so your warning 
> certainly is appropriate for all code at this time.
>   

Sounds like it's referring to micro-architectural reordering, which is
distinct from compiler reordering.  In other words, even if you
specified "-mvolatile-asm-stop" I would assume that the compiler could
still reorder the asm statements.  Am I right, or should I read more
into the manual description than it actually says?

    J
