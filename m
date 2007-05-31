Return-Path: <linux-kernel-owner+w=401wt.eu-S1761699AbXEaTCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761699AbXEaTCr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757130AbXEaTCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:02:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38868 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117AbXEaTCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:02:40 -0400
Date: Thu, 31 May 2007 21:02:37 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531190237.GB7217@one.firstfloor.org>
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070531171616.GC23939@frankl.hpl.hp.com> <20070531172828.GC2538@one.firstfloor.org> <20070531182945.GA9747@infradead.org> <20070531184313.GA7217@one.firstfloor.org> <20070531185323.GA10745@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531185323.GA10745@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> People will want perfom and oprofile in the same kernel, and we'd better

Yes.

> allow useage at the same time, so I'd be very much in favour of having

That would be nice, but is not imho critical.

> just one backend.  Especially giving the huge amount of different
> performance counters we have to support.

It's not that big an issue in my experience -- there aren't new x86 CPUs 
that often and normally they don't change much between minor revisions.
Also at least Intel now has an architected subset of perfctrs
which I expect to cover most people's needs.

-Andi
