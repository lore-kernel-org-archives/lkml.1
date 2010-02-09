Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0BIQvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 11:51:32 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65211 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0BIQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 11:51:29 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19TF8hZMQzEujLtvNvUp0ot
Date: Tue, 9 Feb 2010 08:52:00 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Cc: ext Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaibhav Hiremath <hvaibhav@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
Message-ID: <20100209165200.GH21755@atomide.com>
References: <20100208172521.abb500b4.sfr@canb.auug.org.au>
 <1265621346.2433.27.camel@tubuntu.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265621346.2433.27.camel@tubuntu.research.nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tomi Valkeinen <tomi.valkeinen@nokia.com> [100208 01:23]:
> On Mon, 2010-02-08 at 07:25 +0100, ext Stephen Rothwell wrote:
> > Hi Tomi,
> > 
> > Today's linux-next merge of the omap_dss2 tree got a conflict in
> > arch/arm/mach-omap2/board-am3517evm.c between commit
> > 13560d875d67c06239c82a6148c1b87075701fe9 ("AM3517: Enable basic I2C
> > Support") from the omap tree and commit
> > 56a3d0235cd50d14d7bd4d45e55d192aa0e78cac ("OMAP: AM3517: Enable DSS2 for
> > AM3517EVM board") from the omap_dss2 tree.
> > 
> > Juts overlapping additions.   I fixed it up (see below) and can carry the
> > fix as necessary.
> 
> Thanks. I guess we can't properly fix this until the patch from omap
> tree goes into mainline.

Let's move the AM3517 DSS2 board patch from Tomi's tree to omap for-next
tree.
 
> Tony, do you think this current way, in which we have board file changes
> in both linux-omap and the dss tree, is best we can do? Or should all
> the board file changes go through linux-omap? I fear that we will have
> conflicts with every new board.

Yeah we should just move the conflicting files into omap for-next. The board
file changes conflict easily when new platform device init code is being
added.

Tomi, how about you ack and let me know about the patches (or git branch)
you want me to add into omap for-next? Otherwise I'll assume anything
DSS2 related is yours.

Regards,

Tony

