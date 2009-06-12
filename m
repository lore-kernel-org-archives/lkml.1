Return-Path: <linux-kernel-owner+w=401wt.eu-S1764115AbZFLKAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764115AbZFLKAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933416AbZFLKA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:00:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39822 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778AbZFLKA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:00:28 -0400
Subject: Re: [PATCH v2] slab,slub: ignore __GFP_WAIT if we're booting or 
 suspending
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <1244800695.7172.115.camel@pasglop>
References: <Pine.LNX.4.64.0906121113210.29129@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121201490.30049@melkki.cs.Helsinki.FI>
	 <20090612091002.GA32052@elte.hu> <1244798515.7172.99.camel@pasglop>
	 <84144f020906120224v5ef44637pb849fd247eab84ea@mail.gmail.com>
	 <1244799389.7172.110.camel@pasglop>
	 <Pine.LNX.4.64.0906121244020.30911@melkki.cs.Helsinki.FI>
	 <1244800695.7172.115.camel@pasglop>
Date: Fri, 12 Jun 2009 13:00:29 +0300
Message-Id: <1244800829.30512.40.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Benjamin Herrenschmidt wrote:
> > > Take a break, take a step back, and look at the big picture. Do you
> > > really want to find all the needles in the haystack or just make sure
> > > you wear gloves when handling the hay ? :-)

On Fri, 2009-06-12 at 12:45 +0300, Pekka J Enberg wrote:
> > Well, I would like to find the needles but I think we should do it with 
> > gloves on.
> > 
> > If everyone is happy with this version of Ben's patch, I'm going to just 
> > apply it and push it to Linus.

On Fri, 2009-06-12 at 19:58 +1000, Benjamin Herrenschmidt wrote:
> Thanks :-) Looks right at first glance. I'll test tomorrow.

Nick? I do think this is the best short-term solution. We can get rid of
it later on if we decide to fix up the callers instead.

			Pekka

