Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbYANVCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbYANVCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYANVCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:02:08 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:54848 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYANVCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:02:05 -0500
Date: Mon, 14 Jan 2008 23:01:05 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Oliver Pinter =?utf-8?B?KFBpbnTDqXIgT2xpdsOpcik=?= 
	<oliver.pntr@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@suse.de
Subject: Re: [BUG] skge 0000:02:05: read data parity error
Message-ID: <20080114210105.GG9847@does.not.exist>
References: <6101e8c40801141157j1ce7d3f0if2e4eb2344b6c844@mail.gmail.com> <20080114125200.28cb4c69@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080114125200.28cb4c69@deepthought>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 12:52:00PM -0800, Stephen Hemminger wrote:
> On Mon, 14 Jan 2008 20:57:49 +0100
> "Oliver Pinter (Pintér Olivér)" <oliver.pntr@gmail.com> wrote:
> 
> > Hi All!
> > 
> > It is fully reproductable under 2.6.22.15, 2.6.23.13 (all tainted and
> > not tainted [4 different kernel] ) and 2 different PC:
> > 
> > [BUG] skge 0000:02:05: read data parity error
> > [BUG] skge 0000:02:05: read data parity error
> > 
> > steps:
> > 1. login as root
> > 2. start mc
> > 3. cd /sys/bus/pci/drivers/skge/0000:02:05.0
> > 4. press F3 (mcview) on resource0
> > 5. the system hang up, without panic or bug ... only this message
> > printed 2x: [BUG] skge 0000:02:05: read data parity error
> 
> This is not a bug.
> 
> The hardware has some debug registers that if accessed cause a read
> back to the host. Since this can point anywhere, it will cause errors
> or system hang.
> 
> The point is don't do it.

Is it really a good idea that _reading_ files under /sys can kill your 
machine?

That sounds like a huge trap for people debugging their machine (or e.g. 
forgetting to exclude /sys from their backup).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

