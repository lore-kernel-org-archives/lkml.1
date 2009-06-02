Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbZFBOBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbZFBOBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZFBOBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:01:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34861 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbZFBOBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:01:21 -0400
Date: Tue, 2 Jun 2009 16:08:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602140830.GR1065@one.firstfloor.org>
References: <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602125713.GG1392@wotan.suse.de> <20090602134659.GA21338@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602134659.GA21338@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > We could probably call truncate_complete_page(), but then
> > > we would also need to duplicate most of the checking outside
> > > the function anyways and there wouldn't be any possibility
> > > to share the clean/dirty variants. If you insist I can
> > > do it, but I think it would be significantly worse code
> > > than before and I'm reluctant to do that.
> > 
> > I can write you the patch for that too if you like.
> 
> I have already posted one on truncate_complete_page(). Not the way you want it?

Sorry I must have missed it (too much mail I guess). Can you repost please?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
