Return-Path: <linux-kernel-owner+w=401wt.eu-S1758301AbXFUVJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301AbXFUVJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbXFUVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:09:33 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50557 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbXFUVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:09:32 -0400
Subject: Re: [PATCH for 2.6.22] [6/10] x86: Only make Macintosh drivers
	default on Macs
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Olaf Hering <olaf@aepfle.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070621185442.GA23424@aepfle.de>
References: <200706201223.443613000@suse.de>
	 <20070620102334.DD01814AD0@wotan.suse.de>
	 <20070621173628.GA21243@aepfle.de>
	 <1182448725.25426.19.camel@farscape.rchland.ibm.com>
	 <alpine.LFD.0.98.0706211125100.3593@woody.linux-foundation.org>
	 <20070621185442.GA23424@aepfle.de>
Content-Type: text/plain
Organization: IBM
Date: Thu, 21 Jun 2007 16:09:14 -0500
Message-Id: <1182460154.25426.31.camel@farscape.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 20:54 +0200, Olaf Hering wrote:
> On Thu, Jun 21, Linus Torvalds wrote: 
> > 
> > On Thu, 21 Jun 2007, Will Schmidt wrote:
> > >
> > > I'll second that.  The obvious gotcha is that on a G5, the windfarm
> > > drivers don't get automatically selected, thus the fans run at full
> > > speed, and my office becomes a windtunnel. :-) 
> > 
> > Since when has "default" been anything but "default". It doesn't mean that 
> > you can't override it. And if "make oldconfig" doesn't take the _old_ 
> > setting into account over the new one, there's something wrong.

> I said no to all new options (except IDE_PROC_FS and FIREWIRE), until
> CONFIG_MACINTOSH_DRIVERS. If I say y, everything else was disabled.
> 
>   mkdir ../$$$$
>   gzip  -cd  < /tmp/config.gz > ../$$$$/.config
>   make -kj3 O=../$$$$ ARCH=powerpc
> 

I copy in the g5_defconfig and then do my "make oldconfig".   which
eventually prompts with:
	Macintosh device drivers (MACINTOSH_DRIVERS) [N/y] (NEW)     

But I see what got me..    The g5_defconfig hasnt been updated since
before the MACINTOSH_DRIVERS option was added back in April; so I have
no old setting to carry over into the new.

Unless someone beats me to it, I'll spin up a new g5_defconfig via the
ppc-dev list shortly.   :-)

-Will

