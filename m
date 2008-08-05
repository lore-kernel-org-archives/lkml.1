Return-Path: <linux-kernel-owner+w=401wt.eu-S1762302AbYHESRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762302AbYHESRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 14:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761180AbYHESRB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 14:17:01 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37100 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbYHESRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 14:17:00 -0400
Date: Tue, 5 Aug 2008 21:15:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Bernhard Fischer <rep.dot.nop@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
       linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       bcrl@kvack.org, linux-aio@kvack.org, akpm@linux-foundation.org
Subject: Re: [patch 1/4] Configure out AIO support
Message-ID: <20080805181536.GH22895@cs181140183.pp.htv.fi>
References: <20080731092703.661994657@free-electrons.com> <20080731093220.690886851@free-electrons.com> <20080731100929.GA9206@mx.loc> <20080731101219.GC4221@cs181140183.pp.htv.fi> <20080731224222.GB9208@mx.loc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080731224222.GB9208@mx.loc>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 12:42:22AM +0200, Bernhard Fischer wrote:
> On Thu, Jul 31, 2008 at 01:12:19PM +0300, Adrian Bunk wrote:
> >On Thu, Jul 31, 2008 at 12:09:29PM +0200, Bernhard Fischer wrote:
> >> On Thu, Jul 31, 2008 at 11:27:04AM +0200, Thomas Petazzoni wrote:
> >> >This patchs adds the CONFIG_AIO option which allows to remove support
> >> >for asynchronous I/O operations, that are not necessarly used by
> >> >applications, particularly on embedded devices. As this is a
> >> >size-reduction option, it depends on CONFIG_EMBEDDED. It allows to
> >> >save ~7 kilobytes of kernel code/data:
> >> 
> >> Shouldn't this also make sure not to install aio_abi.h or at least an
> >> empty aio_abi.h?
> >
> >The userspace headers are independent of any kernel configuration
> >(except for the architecture).
> 
> I beg to disagree:
> internals as exposed by e.g. aio_abi.h are impl dependent. Noone except
> the impl and it's users are interrested in it.
>...

That's utter bullshit.

The contents of aio_abi.h is a kernel<->userspace ABI that mustn't ever 
change. [1]

cu
Adrian

[1] there are some exceptions like adding stuff (but not in existing 
    structs), but basically the contents of aio_abi.h is cast in stone

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

