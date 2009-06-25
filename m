Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZFYQf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZFYQf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZFYQfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:35:17 -0400
Received: from outbound-mail-13.bluehost.com ([69.89.18.113]:34381 "HELO
	outbound-mail-13.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753055AbZFYQfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:35:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=iStzZzn9IFEOyLCTx5KTdSKzn0QPblgHO5deUavT+C5wrZvMGRzUfbbGi9F9dlfftpIXb6Tb8VJrj0PWdRIpFQ4WrM1OfbUKr/mP9G/FKqcnZg2Ohk2YSLwa4aqOTb6s;
Date: Thu, 25 Jun 2009 09:28:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Gary Hade <garyhade@us.ibm.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one
 root bus
Message-ID: <20090625092835.77fbd732@jbarnes-g45>
In-Reply-To: <20090625070347.GB2676@elte.hu>
References: <20090624122433.GA24781@elte.hu>
	<20090624145119.GA12664@elte.hu>
	<4A429EBB.5010209@kernel.org>
	<4A42AFAC.6000300@kernel.org>
	<alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
	<alpine.LFD.2.01.0906241615160.18460@localhost.localdomain>
	<20090624163705.0389c8f0@jbarnes-g45>
	<alpine.LFD.2.01.0906241645300.3605@localhost.localdomain>
	<20090624170114.385322df@jbarnes-g45>
	<20090625070347.GB2676@elte.hu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009 09:03:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > > [ There's a difference between "we're supposed to find and fix
> > > bugs in the -rc series", and "I release known-buggy -rc1's since
> > > we're supposed to fix it later". For similar reasons, I hate
> > > pulling known-buggy stuff during the merge window - it's ok if it
> > > shows itself to be buggy _later_, but if people send me stuff
> > > that they know is buggy as they send it to me, then that's a
> > > problem. ]
> > 
> > Yeah, 100% agreed.  I didn't hear any reports until after people 
> > started using your tree, so I think this case was handled 
> > correctly: push something that *seems* ok upstream, but with eyes 
> > wide open for the possibility we'd need to revert.
> 
> There's only one small gripe i have with the handling of it: the 
> timing. "9e9f46c: PCI: use ACPI _CRS data by default" was written 
> and committed on June 11th, two days _after_ the merge window 
> opened.
> 
> That's way too late for maybe-broken changes to x86 lowlevel details 
> (especially if it touches hw-environmental interaction - which is 
> very hard to test with meaningful coverage), and it's also pretty 
> much the worst moment to solicit testing from people who are busy 
> getting their stuff to Linus and who are busy testing out any of the 
> unexpected interactions and bugs.

True, the patch had been around long before that and I definitely
should have committed it sooner.

-- 
Jesse Barnes, Intel Open Source Technology Center
