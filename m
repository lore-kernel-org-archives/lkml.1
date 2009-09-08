Return-Path: <linux-kernel-owner+w=401wt.eu-S1750985AbZIHQmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750985AbZIHQmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbZIHQmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:42:10 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:12967 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940AbZIHQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:42:09 -0400
X-Trace: 259558730/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.112.247/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.112.247
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAIMlpkpPRXD3/2dsb2JhbACBU91QhBgF
X-IronPort-AV: E=Sophos;i="4.44,353,1249254000"; 
   d="scan'208";a="259558730"
Date: Tue, 8 Sep 2009 17:40:50 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nick Piggin <npiggin@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 7/8] mm: reinstate ZERO_PAGE
In-Reply-To: <20090908153441.GB29902@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0909081735230.18233@sister.anvils>
References: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
 <Pine.LNX.4.64.0909072238320.15430@sister.anvils> <20090908073119.GA29902@wotan.suse.de>
 <Pine.LNX.4.64.0909081258160.25652@sister.anvils> <20090908153441.GB29902@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Sep 2009, Nick Piggin wrote:
> On Tue, Sep 08, 2009 at 01:17:01PM +0100, Hugh Dickins wrote:
> > By the way, in compiling that list of "special" architectures,
> > I was surprised not to find ia64 amongst them.  Not that it
> > matters to me, but I thought the Fujitsu guys were usually
> > keen on Itanium - do they realize that the special test is
> > excluding it, or do they have their own special patch for it?
> 
> I don't understand your question. Are you asking whether they
> know your patch will not enable zero pages on ia64?

That's what I was meaning to ask, yes; but wondering whether
perhaps they've already got their own patch to enable pte_special
on ia64, and just haven't got around to sending it in yet.

> 
> I guess pte special was primarily driven by gup_fast, which in
> turn was driven primarily by DB2 9.5, which I think might be
> only available on x86 and ibm's architectures.
> 
> But I admit to being a curious as to when I'll see a gup_fast
> patch come out of SGI or HP or Fujitsu :)

Yes, me too!

Hugh
