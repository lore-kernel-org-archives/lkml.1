Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbYDAL3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbYDAL3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757093AbYDAL3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:29:06 -0400
Received: from www.tglx.de ([62.245.132.106]:37147 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757055AbYDAL3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:29:04 -0400
Date: Tue, 1 Apr 2008 13:24:59 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, paulus@samba.org,
       ralf@linux-mips.org, davem@davemloft.net, lethal@linux-sh.org,
       jdike@addtoit.com
Subject: Re: tick-common.c hack for s390 needed
In-Reply-To: <20080401110257.GA7744@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.LFD.1.10.0804011324080.3219@apollo.tec.linutronix.de>
References: <20080318093119.GA8669@osiris.boeblingen.de.ibm.com> <20080319054545.GA18834@infradead.org> <20080321101504.GI20420@elte.hu> <20080321132559.GA4128@osiris.boeblingen.de.ibm.com> <alpine.LFD.1.00.0803211545160.3781@apollo.tec.linutronix.de>
 <20080322203223.GA31521@osiris.boeblingen.de.ibm.com> <20080323223455.GA746@flint.arm.linux.org.uk> <alpine.LFD.1.00.0803252002100.3781@apollo.tec.linutronix.de> <20080401110257.GA7744@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Heiko Carstens wrote:
> > That patch makes a lot of sense and resolves all the issues. 
> > 
> > I push it through hrt.git and add the GENERIC_HARDIRQS dependency
> > which was requested by Heiko.
> 
> Thomas, would you mind if we push this patch via git-s390?
> As far as I can see s390 is the only architecture which has a dependency on
> this patch. This would make merging our NO_IDLE_HZ to GENERIC_CLOCKEVENTS
> conversion easier.
> I'd take the version you have in your mm branch in your hrt tree, if you're
> ok with this.

Ok, I drop it.

Thanks,
	tglx
 
