Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbXEaSxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbXEaSxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756464AbXEaSx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:53:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39096 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbXEaSx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:53:26 -0400
Date: Thu, 31 May 2007 19:53:24 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531185323.GA10745@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070531171616.GC23939@frankl.hpl.hp.com> <20070531172828.GC2538@one.firstfloor.org> <20070531182945.GA9747@infradead.org> <20070531184313.GA7217@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531184313.GA7217@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 08:43:14PM +0200, Andi Kleen wrote:
> > I think the perform backend for oprofile is the right way to go.
> > I'd even go further and say we should merge the perfom backend with
> > oprofile as the only user first, because a) the current perfom user
> > interface is a complete mess 
> 
> Can you suggest concrete criticism/improvements/alternative proposals to 
> Stephane then? 

Actually writing up a proposal for an alternate inferface is obviously
a lot of work, that I can't just do while reading a mail.  I've put
it on my todo list for the next weekends.

> > and can't be merged as-is and b) that
> > ensures the oprofile backend works perfectly and we can kill some
> > existing code in exchange.
> 
> Hmm, but at least for oprofile like functionality oprofile code seems
> much simpler. And it's not really bad code. I assume the user interface
> would change too.  I think it's better to let them coexist for some time.

People will want perfom and oprofile in the same kernel, and we'd better
allow useage at the same time, so I'd be very much in favour of having
just one backend.  Especially giving the huge amount of different
performance counters we have to support.
