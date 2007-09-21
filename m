Return-Path: <linux-kernel-owner+w=401wt.eu-S933649AbXIUWxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbXIUWxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764849AbXIUWd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:33:58 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4028 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764843AbXIUWd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:33:57 -0400
Subject: RE: Message codes (Re: [Announce] Linux-tiny project revival)
From: Joe Perches <joe@perches.com>
To: "Gross, Mark" <mark.gross@intel.com>
Cc: Rob Landley <rob@landley.net>, Oleg Verych <olecom@flower.upol.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Michael Opdenacker <michael@free-electrons.com>, linux-tiny@selenic.com,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <5389061B65D50446B1783B97DFDB392D0715BCA1@orsmsx411.amr.corp.intel.com>
References: <46F1645D.9050406@am.sony.com> <E1IYWps-0006fQ-83@flower>
	 <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com>
	 <200709211615.39898.rob@landley.net>
	 <5389061B65D50446B1783B97DFDB392D0715BCA1@orsmsx411.amr.corp.intel.com>
Content-Type: text/plain
Date: Fri, 21 Sep 2007 15:33:18 -0700
Message-Id: <1190413998.32660.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-21 at 15:12 -0700, Gross, Mark wrote:
> Use compiler tricks to remove ALL the static printk string from
> the kernel and replace the printk with something that outputs a
> decimal index followed by tuples, of zero to N, hex-strings on

> I proposed a mechanism for keeping all the printk data and saving space
> buy doing some table based compressions that has the side effect of
> making the syslog not human readable.  You proposed a mechanism for
> no-oping out complete log-levels.   

How about compiler tricks to compress the static printk strings?
These could be expanded at runtime to use as the format.

Timothy Miller suggested something similar awhile ago.

