Return-Path: <linux-kernel-owner+w=401wt.eu-S1764130AbXIMXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764130AbXIMXRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 19:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbXIMXRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 19:17:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:49347 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXIMXRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 19:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZiBEmsoJmlhfzuuYE/F9Re1QIk2XYEjmw2gVYYLU3bCj9mwO9A9yW/3iBFD3Pla6hOui23KQBOP2VmeVe1a8bW3Q5Yp4TOz/rn1UZrR4c1ZPbGdP7g7Qz0uXGNTFiNSRJSxjUtPa9uRoMti4uup+aLN+fSBak4bzi5oZYUAX3bk=
Message-ID: <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
Date: Fri, 14 Sep 2007 01:17:05 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Steven Toth" <stoth@hauppauge.com>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <46E99F36.8090809@hauppauge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46C1BCC5.9090709@amd.com> <1189626560.5160.57.camel@gaivota>
	 <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709121610n1a78225cs26380b7ca586344a@mail.gmail.com>
	 <20070913131353.GB26972@linuxtv.org>
	 <d9def9db0709130712h108c7c1obfe24833f5dc27a1@mail.gmail.com>
	 <46E95C54.4060502@gmail.com>
	 <d9def9db0709130908r6e383c51wd115dd56cfe2beef@mail.gmail.com>
	 <46E99F36.8090809@hauppauge.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Steven Toth <stoth@hauppauge.com> wrote:
>
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
Steven,

what stops vendors of using the current existing code to achieve that
goal. They could provide binary drivers with the existing API.

What stops companies to intercept the ioctl calls and overriding some
I2C commands?

Since you know about windows drivers (at least I think that you know
about it) you might know about the limitations of the v4l/dvb API
in general the reason just put as much code as possible into the
kernel just for forcing companies to release code under GPL doesn't
seem to be valid.
How about proprietary video formats, would you also place the decoding
algorithms in kernel  just to force companies to release their code
for it?
What do you think about the existing usbfs implementation, which
allows to implement usb drivers completly in userspace?
What do you think about IOMMU?

please answer those questions.

thanks,
Markus
