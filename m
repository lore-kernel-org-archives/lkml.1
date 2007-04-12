Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXDLS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXDLS66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbXDLS66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 14:58:58 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:55071 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325AbXDLS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 14:58:57 -0400
Date: Thu, 12 Apr 2007 20:52:05 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: usb touchscreen breakage in 2.6.21-rc5-mm4 ?
Message-ID: <20070412185205.GA12676@aitel.hist.no>
References: <20070407005458.GA18985@aitel.hist.no> <200704062237.13118.dtor@insightbb.com> <20070409223643.GB2198@aitel.hist.no> <200704092230.04144.dtor@insightbb.com> <461B9DFF.9080704@aitel.hist.no> <d120d5000704100839s47d07ff1gc47ce9ea97d54002@mail.gmail.com> <461CAF73.3020201@aitel.hist.no> <d120d5000704110737o2d74b734xfc5756eac9dbbc29@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000704110737o2d74b734xfc5756eac9dbbc29@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 10:37:11AM -0400, Dmitry Torokhov wrote:
> On 4/11/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> >Dmitry Torokhov wrote:
> >>
> >> *sigh* When will I learn to spell names of kernel parameters
> >> correctly? It is initcall_debug, not debug_initcall :( Could you try
> >> again, please?
> >Here is the dmesg for rc5mm4 with initcall_debug, showing how
> >no usbtouch function is called at all.
> >
> 
> Helge,
> 
> I don't have any explanation why we don't see usbtouch_init called at
> all in -rc5-mm4. Could it be toolchain misbehaving? Do you see
> references to usbtouch_init in the kernel image itself?
> 
I unpacked it, ran "strings" on it, and found no usbtouch in there.
There were plenty of other usb names, such as usbfs, usbserial, usbcore
and tons of messages that usb mass storage and usb serial might
need to produce.

Versions of some tools, I don't know if there are any
known issues:

$ gcc --version
gcc (GCC) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)
$ ld --version
GNU ld (GNU Binutils for Debian) 2.17.50.20070406
$ dpkg -l binutils
ii  binutils       2.17.20070406c The GNU assembler, linker and binary

Helge Hafting
