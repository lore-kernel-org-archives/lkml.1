Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZJGWEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZJGWEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZJGWEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:04:42 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63635 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZJGWEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:04:41 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+32wiAC0aCt40GxosjiGG3
Date: Wed, 7 Oct 2009 15:03:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Venkatraman S <svenkatr@ti.com>, Anuj Aggarwal <anuj.aggarwal@ti.com>,
       linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] SDMA: Fixing bug in omap_dma_set_global_params()
Message-ID: <20091007220354.GC29320@atomide.com>
References: <1254732163-3509-1-git-send-email-anuj.aggarwal@ti.com> <20091005094102.1385b418.rdunlap@xenotime.net> <618f0c910910070218q496eeb9dgf200ffd5d6583aef@mail.gmail.com> <20091007083836.89b48fbd.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20091007083836.89b48fbd.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap <rdunlap@xenotime.net> [091007 08:38]:
> On Wed, 7 Oct 2009 14:48:26 +0530 Venkatraman S wrote:
> 
> > On Mon, Oct 5, 2009 at 10:11 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > > On Mon,  5 Oct 2009 14:12:43 +0530 Anuj Aggarwal wrote:
> > >
> > >> Argument tparams was not being used to program
> > >> global register GCR.HI_THREAD_RESERVED. This patch fixes the same.
> > >>
> > >> Signed-off-by: Anuj Aggarwal <anuj.aggarwal@ti.com>
> > >> ---
> > >>  arch/arm/plat-omap/dma.c |   15 +++++++++------
> > >>  1 files changed, 9 insertions(+), 6 deletions(-)
> > >
> > >
> > > Hi,
> > > Someone please convert all of this source file to correct kernel-doc notation.
> > >
> > > Thanks.
> > >
> > 
> > I now have this on my TODO list. As a bug fix, shouldn't this be
> > pulled in and the doc updates for all the functions can be done as a
> > separate patch ?
> 
> Yes.  Thanks.

Will add this fix to my omap-fixes queue.

Tony

> 
> > Anuj,
> >  Can you please correct the comments for this function to proper
> > format along with your changes ?
> > 
> > Thanks,
> > Venkat.
> 
> 
> ---
> ~Randy
