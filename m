Return-Path: <linux-kernel-owner+w=401wt.eu-S1760955AbXINAtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760955AbXINAtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 20:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXINAtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 20:49:42 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:33388 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753271AbXINAtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 20:49:41 -0400
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
From: hermann pitton <hermann-pitton@arcor.de>
To: Steven Toth <stoth@hauppauge.com>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Manu Abraham <abraham.manu@gmail.com>
In-Reply-To: <46E99F36.8090809@hauppauge.com>
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 02:49:28 +0200
Message-Id: <1189730968.7105.11.camel@pc06.localdom.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-2.fc5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 13.09.2007, 16:36 -0400 schrieb Steven Toth:
> >   
> >> Also there is to consider a non technical aspect, whether vendors will
> >> misuse this interface for binary only, undermining the efforts put in
> >> for OSS drivers.
> >>
> >>     
> >
> > What holds companies for using the current available code putting it
> > into an rpm or deb package and releasing such code now?
> >
> > The Avermedia example I pointed out to is a good example already.
> > As from my side I won't release binary drivers.
> > Although on the other side:
> > * are drivers from vendors which work through several kernel versions
> > that bad?
> > * Why did someone duallicense videodev2 with BSD/GPL?
> >
> > I would appreciate if someone else on the list could also comment
> > the reason that drivers should all be included in the linuxkernel just
> > because forcing the companies to release binary drivers because
> > of that. My opinion about that is if a company wants to go opensource
> > they will do so, if not they will either not release a driver or release
> > nothing.
> >
> >   
> 
> 
> I know for certain that adding a userland API tuner/demod interface to 
> the kernel, allowing non-caring opportunistic silicon or board vendors 
> to developer closed source proprietary drivers, will have a negative 
> effect on the community and we'd set back linuxtv 3-5 years.
> 
> I know for certain that it would happen. Trust me.
> 
> I've told you this countless times and you're not hearing me.
> 
> Hauppauge have some leverage with Conexant and NXP to release public 
> datasheets. If they just have to release a demod.so (or similar) 
> loadable, they'll defer to the board vendors and we'll see the certain 
> board vendors 'locking other board vendors' out of their drivers. We'll 
> see embedded firmware, not shared between drivers.
> 
> Except, it won't stop at demod.so. It will extend into unfixable bugs 
> for VendorB's board, because VendorA doesn't want to release a new 
> demod.so, and VendorB has no linux resources. What happens next? For 
> financial reasons - demod.so will begin to include checks to see if 
> specific PCI or USB devices are present in the system, and will fail to 
> work properly (if at all) when they're not being used with the preferred 
> products.
> 
> Read my lips: For commercial reasons, this enables driver components 
> that only work if specific boards are present.
> 
> - Steve
> 

I do confirn that I have all this, Steve mentions, really have seen
already!

Markus, sorry, they did abuse it and will do it again.

Hermann


