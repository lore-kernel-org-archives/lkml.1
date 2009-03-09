Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbZCIUhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbZCIUhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538AbZCIUh0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:37:26 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:27920 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446AbZCIUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:37:25 -0400
Date: Mon, 9 Mar 2009 14:37:19 -0600
From: Alex Chiang <achiang@hp.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, xyzzy@speakeasy.org, djwong@us.ibm.com,
       shimada-yxb@necst.nec.co.jp, rjw@sisk.pl, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] PCI core learns hotplug
Message-ID: <20090309203719.GR32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
	jbarnes@virtuousgeek.org, xyzzy@speakeasy.org, djwong@us.ibm.com,
	shimada-yxb@necst.nec.co.jp, rjw@sisk.pl, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090309052933.3918.86601.stgit@bob.kio> <20090309185117.GJ32589@ldl.fc.hp.com> <19f34abd0903091230q27a04f37mdb0ba75ba170e6a@mail.gmail.com> <20090309195250.GQ32589@ldl.fc.hp.com> <19f34abd0903091328q4471bb3he0c6e07fa32a6a1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0903091328q4471bb3he0c6e07fa32a6a1f@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vegard Nossum <vegard.nossum@gmail.com>:
> 2009/3/9 Alex Chiang <achiang@hp.com>:
> >> It reproduces reliably if I do this:
> >>
> >> $ while true; do echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/remove; done
> >
> > I was going to ask for lspci -v output so that I could see what
> > device 0000:00:00.0 might be, but I was able to reproduce
> > something similar on my machine.
> >
> > Can I ask why you're doing the above with a while loop? Just to
> > torture the code? Or something else?
> 
> Yes, purely for the purpose of torture ;-)
 
Ok, just checking. :)

> I also found one more use-after-free error using kmemcheck:
> 
> Hope this helps :-)

Yes, thanks a lot!

I'll work on these. Thanks for the excellent bug reports.

/ac

