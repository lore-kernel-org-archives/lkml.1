Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYEAKfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYEAKfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 06:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYEAKff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 06:35:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51957 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbYEAKfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 06:35:34 -0400
Date: Thu, 1 May 2008 12:41:58 +0200
From: Andi Kleen <andi@firstfloor.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Tim Bird <tim.bird@am.sony.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Embedded Maintainer(s), linux-embedded@vger list
Message-ID: <20080501104158.GM20451@one.firstfloor.org>
References: <1209577322.25560.402.camel@pmac.infradead.org> <87bq3rgq40.fsf@basil.nowhere.org> <48190B5F.9010505@am.sony.com> <20080501095822.GL20451@one.firstfloor.org> <1209636171.25560.508.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209636171.25560.508.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To a large extent, I agree. I certainly don't want to focus solely on
> code size; there's a lot more to embedded Linux than that. But it _is_

Not only code size, far more important is dynamic memory consumption.
[admittedly we right now lack a good instrumentation framework for this]

> There are some cases where we really _do_ want to have CONFIG options,
> but I agree that we should keep them to a minimum. And when we _do_ have
> CONFIG options, they don't have to litter the actual code with ifdefs.

The problem I see is more that really nobody can even compile not 
alone test all these combinations anymore. Hidding the problem in inlines
does not solve that. And no randconfig is not the solution either.

> > of years ago with some numbers 
> > (http://halobates.de/memory.pdf and http://halobates.de/memorywaste.pdf) 
> > And CONFIG is definitely not the right way to approach that, the right
> > way is better data structures, better algorithms to size tables, just
> > some general care etc.
> 
> Stuff like shrinking the rbtree structure by encoding the colour in the
> low bits of the parent pointer, perhaps? :)

Whatever pays off.

-Andi
