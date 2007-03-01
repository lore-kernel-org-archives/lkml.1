Return-Path: <linux-kernel-owner+w=401wt.eu-S965425AbXCARTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbXCARTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:19:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965430AbXCARTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:19:45 -0500
Received: from thoth.sbs.de ([192.35.17.2]:24201 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965425AbXCARTo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:19:44 -0500
X-Greylist: delayed 2880 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Mar 2007 12:19:44 EST
From: "Hillier, Gernot" <gernot.hillier@siemens.com>
Organization: Siemens AG, CT SE 2
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: MOST(Media Oriented Systems Transport) Interface?
Date: Thu, 1 Mar 2007 17:31:35 +0100
User-Agent: KMail/1.9.5
Cc: "Bernhard Walle" <bernhard.walle@gmx.de>, "Jan Kiszka" <jan.kiszka@web.de>,
       linux-kernel@vger.kernel.org
References: <200702231826.30395.rgetz@blackfin.uclinux.org> <20070301001142.GA6806@strauss.suse.de> <200703011016.08167.rgetz@blackfin.uclinux.org>
In-Reply-To: <200703011016.08167.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703011731.35991.gernot.hillier@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am Donnerstag, 1. März 2007 16:16 schrieb Robin Getz:
> > > http://most4linux.sourceforge.net/
>
> That's it - thanks for the pointer & Bernhard - thanks for the work.
>
> What is the plan for this? It looks like you did the work on 2.6.14, what
> is the plan going forward? Is this something that you or anyone else wants
> to maintain/support newer devices on?

Ok, that's perhaps the point for me to step in. I supervised the thesis of 
Bernhard within our Embedded Linux group at Siemens CT SE 2.

Unfortunately, we currently don't plan doing further enhancements to this 
driver like porting it to other hardware. It was more or less an unplanned 
result of a thesis to show ways how to port drivers to a realtime extension - 
and as it was indeed a very good and usable result (thanks to Bernhard 
again!), we decided to open source it in the hope it might be useful.

However, if a real user community forms around the project, we might rethink 
this decision. However I can't promise anything...

> > It only supports synchronous data transfer. The Most NetServices are
> > in userspace. There's a OpenSource demonstration available, but no
> > full NetServices implementation. You can buy a license from SMC or use
> > the specification to re-write an OSS implementation. However, that's
> > all userspace, so no GPL problem here. :)
>
> Is there any effort on making an open source NetServices implementation?

No, definitely not. You can make basic usage of the package without 
NetServices (we provide small examples which don't need NetServices), but for 
real-world product usage you might still need to buy a NetServices license 
from SMSC.

-- 
Bye,
Gernot Hillier

Siemens AG
CT SE 2
