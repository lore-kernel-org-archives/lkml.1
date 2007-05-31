Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbXEaSna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbXEaSna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760378AbXEaSnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:43:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43901 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759355AbXEaSnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:43:17 -0400
Date: Thu, 31 May 2007 20:43:14 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Stephane Eranian <eranian@hpl.hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/22] 2.6.22-rc3 perfmon2 : common core functions
Message-ID: <20070531184313.GA7217@one.firstfloor.org>
References: <200705291348.l4TDmRvL019775@frankl.hpl.hp.com> <p73ira9ca0d.fsf@bingen.suse.de> <20070531171616.GC23939@frankl.hpl.hp.com> <20070531172828.GC2538@one.firstfloor.org> <20070531182945.GA9747@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531182945.GA9747@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think the perform backend for oprofile is the right way to go.
> I'd even go further and say we should merge the perfom backend with
> oprofile as the only user first, because a) the current perfom user
> interface is a complete mess 

Can you suggest concrete criticism/improvements/alternative proposals to 
Stephane then? 

> and can't be merged as-is and b) that
> ensures the oprofile backend works perfectly and we can kill some
> existing code in exchange.

Hmm, but at least for oprofile like functionality oprofile code seems
much simpler. And it's not really bad code. I assume the user interface
would change too.  I think it's better to let them coexist for some time.

-Andi
