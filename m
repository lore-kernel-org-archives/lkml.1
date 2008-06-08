Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYFHWJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYFHWJs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756585AbYFHWJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:09:40 -0400
Received: from smtps.uol.com.br ([200.221.4.131]:38559 "EHLO smtp.uol.com.br"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756403AbYFHWJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:09:40 -0400
Date: Sun, 8 Jun 2008 19:09:34 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc
Message-ID: <20080608220934.GA22242@ime.usp.br>
References: <20080601193000.GA3056@ime.usp.br> <200806081242.54896.IvDoorn@gmail.com> <20080608213513.GA30499@ime.usp.br> <200806090002.17938.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200806090002.17938.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SIG5: cf323e32f559880365a8388c22342d51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo.

Thank you very much for your very kind reply.

On Jun 09 2008, Ivo van Doorn wrote:
> Hi,
> 
> > Nice to know that. I saw that the code has changed quite a good
> > amount...
> 
> Hehe, yes rt2x00 code is moving quit a lot per kernel release.

Granted. :-) You have been working quite a lot. :-)

> > Anyway, I don't know if you saw the various outputs that I put at my
> > homepage (lots of dmesgs with the 2.6.26-rc4 kernel):
> > http://www.ime.usp.br/~rbrito/debug/
> 
> Yeah, saw them.

Hope that they prove somewhat useful.

> > > > I don't know if the firmware is needed in my case or not, though (my USB
> > > > adaptor is a D-Link DWL-G122 H/W Ver. B1, F/W Ver.: 2.03---took that info
> > > > from the back of the stick).
> > > 
> > > Which driver is actually being used? rt2500usb or rt73usb?
> > 
> > The driver that actually gets loaded is rt2500usb. I tried rmmod'ing
> > rt2500usb and loading rt73usb, but a quick iwconfig doesn't even show
> > the interfaces.
> 
> That means it really is a rt2500usb device. ;)

Yes. :) I have firmware files installed under /lib/firmware also (taken
from Debian's unstable release---which is what I am using). Are they
needed?

> > > Also what was the last kernel version on which the driver worked for
> > > you?
> > 
> > Unfortunately, I don't have any kernel for which this has worked for
> > me. I just did an experiment: I plugged the adaptor on a ia32
> > notebook where a rt61pci works fine (it is running Ubuntu's
> > Hardy---well, actually, there are some problems, but I can get to
> > that latter), but the USB key was non working with the symptoms that
> > I described above.
> 
> That is most unfortunate, since register dumps are usually most usefull when
> I can compare the actual register values between a working and
> non-working setup.

Ok. I will try to compile an 2.6.18 kernel with the out-of-tree modules.
I hope that this can prove useful. I plan on getting register dumps (and
I also hope that it will work; perhaps getting the register values with
the legacy rt2500 drivers would help you, if they are available at all.
I don't even know if they will work here, but I guess that I will give
them a shot).

> However I just realized I had a D-Link stick myself, and apparently I have the exact
> same model/type. I'll compile a 2.6.26-rc5 kernel and see if that stick works for me,
> if so, I have the working register dump. And if not, then we can rule
> out endian problems.

Thank you so much.

I will compile other versions of the kernel just to see if I can see the
status of the driver with other versions of kernels/drivers. Since I
just installed a cross-compiler yesterday night on a *much* faster
machine, I don't have to wait more than 1 hour for each kernel
modification that I make (this iBook is slow).

As I said earlier, I plan on doing whatever test you want me to.


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
