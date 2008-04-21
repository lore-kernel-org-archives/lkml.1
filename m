Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYDUMYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYDUMYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756588AbYDUMYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:24:42 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55790 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbYDUMYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:24:42 -0400
Date: Mon, 21 Apr 2008 15:24:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unexport of blk_get_queue and blk_put_queue
Message-ID: <20080421122413.GD6011@cs181133002.pp.htv.fi>
References: <e2e108260804180443s429e0db7j3a48056088634ed9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e2e108260804180443s429e0db7j3a48056088634ed9@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 01:43:17PM +0200, Bart Van Assche wrote:
> Hello Adrian,

Hi Bart,

> I noticed that blk_get_queue and blk_put_queue were unexported in the
> 2.6.25 kernel. Are you aware that this breaks DRBD (an out-of-tree
> kernel module) ?

no, I verify that my patches don't break Linus' tree and often also peek 
at -mm, but not at external modules.

And I'm a proponent of "no stable kernel API, but as many external 
modules as reasonably possible should be part of the kernel", so emails 
like yours are always a good point to start asking why the code isn't in 
Linus' tree.

What happened to DRBD?
It didn't seem that far from getting merged half a year ago.

> Bart.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

