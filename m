Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZHZVDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZHZVDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZHZVDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:03:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36225 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZHZVDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:03:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [Bug #14011] Kernel paging request failed in kmem_cache_alloc
Date: Wed, 26 Aug 2009 23:03:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Matthias Dahl <ml_kernel@mortal-soul.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <200908261601.05734.ml_kernel@mortal-soul.de> <84144f020908260759q6554971dva6cc89a0ad9821b@mail.gmail.com>
In-Reply-To: <84144f020908260759q6554971dva6cc89a0ad9821b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908262303.51046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 August 2009, Pekka Enberg wrote:
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

I've closed it as "insufficient data".

Thanks,
Rafael
