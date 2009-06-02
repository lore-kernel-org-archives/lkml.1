Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbZFBRMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbZFBRMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZFBRML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 13:12:11 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48952 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbZFBRML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 13:12:11 -0400
Date: Tue, 2 Jun 2009 19:19:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, Wu Fengguang <fengguang.wu@intel.com>,
       "hugh@veritas.com" <hugh@veritas.com>,
       "riel@redhat.com" <riel@redhat.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v3
Message-ID: <20090602171915.GS1065@one.firstfloor.org>
References: <20090527201239.C2C9C1D0294@basil.firstfloor.org> <20090528082616.GG6920@wotan.suse.de> <20090528095934.GA10678@localhost> <20090528122357.GM6920@wotan.suse.de> <20090528135428.GB16528@localhost> <20090601115046.GE5018@wotan.suse.de> <20090601183225.GS1065@one.firstfloor.org> <20090602120042.GB1392@wotan.suse.de> <20090602124757.GG1065@one.firstfloor.org> <20090602150952.GB17448@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602150952.GB17448@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 02, 2009 at 05:09:52PM +0200, Nick Piggin wrote:
> On Tue, Jun 02, 2009 at 02:47:57PM +0200, Andi Kleen wrote:
> > On Tue, Jun 02, 2009 at 02:00:42PM +0200, Nick Piggin wrote:
> 
> [snip: reusing truncate.c code]
> 
> > > With all that writing you could have just done it. It's really
> > 
> > I would have done it if it made sense to me, but so far it hasn't.
> > 
> > The problem with your suggestion is that you do the big picture,
> > but seem to skip over a lot of details. But details matter.
> 
> BTW. just to answer this point. The reason maybe for this
> is because the default response to my concerns seems to
> have been "you're wrong". Not "i don't understand, can you
> detail", and not "i don't agree because ...".

Sorry, I didn't want to imply you're wrong. I apologize if
it came over this way. I understand you understand this code
very well. I realize the one above came out 
a bit flamey, but it wasn't really intended like this.

The disagreement right now seems to be more how the 
code is structured. Typically there's no clear "right" or "wrong"
with these things anyways.

I'll take a look at your suggestion this evening and see
how it comes out.

> Anyway don't worry. I get that a lot. I do really want to
> help get this merged.

I wanted to thank you for your great reviewing work, even if I didn't
agree with everything :) But I think the disagreement were quite
small and only relatively unimportant things.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
