Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXCJN4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXCJN4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 08:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933455AbXCJN4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 08:56:14 -0500
Received: from allen.werkleitz.de ([80.190.251.108]:54076 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767017AbXCJN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 08:56:12 -0500
Date: Sat, 10 Mar 2007 14:53:12 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Stefan Seyfried <seife@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Jeff Chua <jeff.chua.linux@gmail.com>, linux-pm@lists.osdl.org,
       lenb@kernel.org, linux-acpi@vger.kernel.org, luming.yu@intel.com,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       Konstantin Karasyov <konstantin.a.karasyov@intel.com>,
       Greg KH <greg@kroah.com>, linux-usb-devel@lists.sourceforge.net,
       Thomas Meyer <thomas.mey@web.de>, Meelis Roos <mroos@linux.ee>,
       Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>,
       Janosch Machowinski <jmachowinski@gmx.de>, vladimir.p.lebedev@intel.com,
       Ash Milsted <thatistosayiseenem@gawab.com>, dmitry.torokhov@gmail.com
Message-ID: <20070310135312.GA7659@linuxtv.org>
References: <20070305015034.GG3441@stusta.de> <20070308123143.GF5149@mellanox.co.il> <Pine.LNX.4.64.0703080954220.10832@woody.linux-foundation.org> <20070308192554.GA2999@elte.hu> <20070308230705.GA4611@elte.hu> <Pine.LNX.4.64.0703081545110.10832@woody.linux-foundation.org> <20070309174821.GA31754@linuxtv.org> <20070309233508.GB2197@elf.ucw.cz> <20070310090121.GB15647@elte.hu> <20070310114301.GA30554@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310114301.GA30554@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 87.162.126.141
Subject: Re: [2/6] 2.6.21-rc2: known regressions
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 12:43:01PM +0100, Stefan Seyfried wrote:
> On Sat, Mar 10, 2007 at 10:01:21AM +0100, Ingo Molnar wrote:
> > 
> > i'm wondering, do you have any idea how Windows handles the 
> > suspend/resume quirks problem area? Do they "curse BIOS vendors and 
> > maintain a large DB of DMI-driven exceptions", or do they perhaps have 
> > some fundamentally better approach than us? If it's the former, then we 
> > might as well try to bring more automatism (and more of your database) 
> > into the kernel itself.
> 
> I think that in windows, you simply install the "HP nx$FOOBAR intel graphics
> driver" on a nx$FOOBAR machine, and the "ASUS $FOOBAR ATI graphics driver"
> on an ASUS $FOOBAR machine etc. Those drivers are mostly stock intel/ATI/
> whoever drivers, but with the little bit of extra knowledge on how to wake
> up the graphics chip.

That's also what the thinkwiki page suggests. It says:

"Affected Operating Systems:
  * Linux, all flavours.
  * Windows, for some models as well (only when using non-IBM drivers).
  * FreeBSD (on the A22M)"


Johannes
