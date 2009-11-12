Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbZKLSPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbZKLSPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:15:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZKLSPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:15:00 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:56655 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbZKLSO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:14:59 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18yhu/XR9MFS9OIl5mbO4if
Date: Thu, 12 Nov 2009 10:14:57 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
Subject: Re: [PATCH 00/19] OMAP: DSS2 v5 intro
Message-ID: <20091112181457.GX24837@atomide.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
 <1257856848.21596.753.camel@localhost>
 <1257929140.20378.51.camel@tubuntu.research.nokia.com>
 <1257932641.20378.77.camel@tubuntu.research.nokia.com>
 <20091111184208.GC24837@atomide.com>
 <20091112161028.427787d9.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091112161028.427787d9.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Rothwell <sfr@canb.auug.org.au> [091111 21:10]:
> Hi Tony,
> 
> On Wed, 11 Nov 2009 10:42:09 -0800 Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Tomi Valkeinen <tomi.valkeinen@nokia.com> [091111 01:43]:
> > > On Wed, 2009-11-11 at 09:45 +0100, Valkeinen Tomi (Nokia-D/Helsinki)
> > > wrote:
> > > > On Tue, 2009-11-10 at 13:40 +0100, Artem Bityutskiy wrote:
> > > > > 
> > > > > could you please kindly ask Stephen (CCed) to include the DSS2 tree into
> > > > > linux-next, because you are going to merge it the next merge window, and
> > > > > there does not seem to be any blocker for this.
> > > > > 
> > > > > Being in linux-next for a while is really important.
> > > > 
> > > > Stephen, would this be possible? DSS2 driver is rather big piece of
> > > > code, even if it's quite isolated, so it would be nice to have it in
> > > > linux-next.
> > > > 
> > > > What does it require from me? A git tree, obviously, but what should it
> > > > be based on?
> > > 
> > > Ah, I just realized that DSS2 patches depend on patches from Tony's
> > > tree. I guess I should base my tree on top of some Tony's tree that is
> > > going to linux-next?
> > 
> > Or I can merge them into my for-next if that's OK with everybody. This
> > merge cycle is a pain for omap as we've moved all the common headers from
> > include/mach to include/plat.
> 
> If the DSS2 patches really are dependent on other stuff in the omap tree,
> then this is probably the best plan.

OK. The only dependency is the the move of the headers.

Tomi, can you please rebase your patches on top of the "7xx-iosplit-plat-merge"
branch in linux-omap tree? This is commit 8171d88089ad63fc442b2bf32af7c18653adc5cb,
and it should stay static.

Please don't rebase on the for-next branch in linux-omap tree, that's still
changing.

Regards,

Tony
