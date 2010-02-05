Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0BEEEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 23:04:24 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64390 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab0BEEEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 23:04:22 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18no5yy30q5wAX6/7docxpv
Date: Thu, 4 Feb 2010 20:04:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-omap@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the omap tree with the arm tree
Message-ID: <20100205040444.GH22747@atomide.com>
References: <20100205102030.c8b139a1.sfr@canb.auug.org.au>
 <20100204233019.GY22747@atomide.com>
 <20100205111617.c602983f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100205111617.c602983f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [100204 16:13]:
> Hi Tony,
> 
> On Thu, 4 Feb 2010 15:30:19 -0800 Tony Lindgren <tony@atomide.com> wrote:
> >
> > Thanks, I'll sort it out in omap for-next tree so they merge
> > cleanly.

Tried figuring out a clean mergeable solution, but it looks like
I need to manually merge or rebase the omap patches with patch
"ARM: 5910/1: ARM: Add tmp register for addruart and loadsp".

If we move the related debug-macro.S changes from omap tree to
Russell's tree, then I can't build my following multi-omap
patches..

Russell, can you please let me know if you have some static
commit ID containing the patch above that I could use that as
base for my patches?

Regards,

Tony
