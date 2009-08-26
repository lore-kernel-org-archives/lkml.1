Return-Path: <linux-kernel-owner+w=401wt.eu-S1751464AbZHZPIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbZHZPIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 11:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbZHZPIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 11:08:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZHZPIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 11:08:46 -0400
Subject: Re: [Bug #14011] Kernel paging request failed in kmem_cache_alloc
From: Eric Paris <eparis@redhat.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matthias Dahl <ml_kernel@mortal-soul.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <84144f020908260759q6554971dva6cc89a0ad9821b@mail.gmail.com>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera>
	 <_yaHeGjHEzG.A.2bH.CtGlKB@chimera>
	 <84144f020908252317j202aa459u27c40eed34debd6@mail.gmail.com>
	 <200908261601.05734.ml_kernel@mortal-soul.de>
	 <84144f020908260759q6554971dva6cc89a0ad9821b@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 11:08:21 -0400
Message-Id: <1251299301.2308.31.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 17:59 +0300, Pekka Enberg wrote:
> On Wed, Aug 26, 2009 at 5:01 PM, Matthias Dahl<ml_kernel@mortal-soul.de> wrote:
> >> Can you reproduce the bug without the proprietary nvidia module that
> >> seems to be loaded?
> >
> > I am sorry but I forgot to test that and right now I am not very keen on
> > trying again since this is my primary machine and I had quite some fs
> > corruption (ext4 on md raid5 -> no barriers) the last times. :-( But this also
> > happened w/o Xorg ever being run during that session (though naturally the
> > nvidia kernel module was still loaded).
> 
> Sure, I can understand that. The bug looks like regular slab
> corruption which could have been caused the nvidia blob. So I think
> the issue should be closed unless someone can reproduce it without the
> blob.
> 
> That said, sys_inotify_add_watch() also appears in the trace and
> there's been quite a few bug fixes in that area recently so I guess we
> should CC Eric Paris just in case the oops rings a bell to him.

Nope, no bells here  :(   That slab cache is declared globally and
allocated at __init time.  I haven't seen any reports of writes off the
ends of marks which might mess up a chache...  sorry.....

-Eric

