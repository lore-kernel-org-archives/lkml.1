Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZAUGPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZAUGPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 01:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbZAUGPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 01:15:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54120
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbZAUGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 01:15:03 -0500
Date: Tue, 20 Jan 2009 22:15:04 -0800 (PST)
Message-Id: <20090120.221504.264090722.davem@davemloft.net>
To: sam@ravnborg.org
Cc: jaswinderlinux@gmail.com, khc@pm.waw.pl, jaswinder@kernel.org,
       arnd@arndb.de, mingo@elte.hu, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: why usr/include/linux/if_frad.h is required
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090121053310.GA26395@uranus.ravnborg.org>
References: <m3bpu1xyb9.fsf@intrepid.localdomain>
	<3f9a31f40901202050u4b85fef2p8b9848b865c4fda0@mail.gmail.com>
	<20090121053310.GA26395@uranus.ravnborg.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 21 Jan 2009 06:33:10 +0100

> On Wed, Jan 21, 2009 at 10:20:17AM +0530, Jaswinder Singh Rajput wrote:
> > On Wed, Jan 21, 2009 at 6:36 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> > > Jaswinder Singh Rajput <jaswinder@kernel.org> writes:
> > >
> > >> usr/include/linux/if_frad.h is covered with CONFIG_DLCI from many years
> > >> and no body is complaining about it so it means no body is using it.
> > >>
> > >> So should we need to drop #if / #endif pair or the whole file from
> > >> userspace.
> > >
> > > I think the file. "Empty file exported to userspace", long unused. We
> > > can also have it back there, and it being not exported is an indicator
> > > that it's not used. I guess the #ifdef __KERNEL__ can be removed, too.
> > 
> > I will definately define #ifdef __KERNEL__ but I am also curious after
> > defining it there is no point of making empty
> > usr/include/linux/if_frad.h
> 
> Googling a bit did not turn up _any_ non-kernel hits that has relevance.
> So based on the information given in this thread I strongly
> suggest to drop the export of this header.

Sure, but on the other hand this makes all of the userland APIs
essentially inaccessible and undefined.

I bet Sangoma's internal tools reference this stuff.
