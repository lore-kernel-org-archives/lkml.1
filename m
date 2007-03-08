Return-Path: <linux-kernel-owner+w=401wt.eu-S1751922AbXCHOZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922AbXCHOZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXCHOZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:25:54 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:26255 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbXCHOZx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:25:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PSyj2c5NusuYr6y1iR+ZFE7d2Mp5k/mzFr7DcInZ3VDQ8qLwrChuVyM7EKN5DKagZ5G+DuJhnDjwpE2oMR0YccDNnx6SGt+P5eKFheSZDLXkjGyti2csGHl18JW01PApn0O/u0Q9aAkUPTc03rhFtiy0bob6JQ80aF8CYa2PePM=
Message-ID: <57354eff0703080625r783f6e39k5d6b2fe4d335a518@mail.gmail.com>
Date: Thu, 8 Mar 2007 15:25:52 +0100
From: "Oleksiy Kebkal" <kebkal@gmail.com>
To: "Robin Getz" <rgetz@blackfin.uclinux.org>,
       "Oleksiy Kebkal" <kebkal@gmail.com>, "Krzysztof Halasa" <khc@pm.waw.pl>,
       "Mike Frysinger" <vapier.adi@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
In-Reply-To: <20070308134800.GA30023@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com>
	 <200703071019.55896.rgetz@blackfin.uclinux.org>
	 <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com>
	 <200703080844.32157.rgetz@blackfin.uclinux.org>
	 <20070308134800.GA30023@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> On Thu, Mar 08, 2007 at 08:44:31AM -0500, Robin Getz wrote:
> > On Wed 7 Mar 2007 16:30, Oleksiy Kebkal pondered:
> > > 2007/3/7, Robin Getz <rgetz@blackfin.uclinux.org>:
> > > > Right - so the question is where to manage the default state? I was
> > > > thinking in the resource might be a good idea, but there isn't really a
> > > > good place for it. (You could re-use some bits if flags, but I think that
> > > > would not be a good idea).
> > >
> > > /proc/tty/driver/uartN/settings?
> > >
> >
> > That would let you change things are run time, but the problem is at boot
> > time. A default setting needs to be set, so when things initialize, and proc
> > does not exist yet, it is still set properly...
>
> I disagree.  "proc does not exist yet" - the only time that applies is
> long before userspace as active.
>
> As I've said already, having a console on the same port as your application
> program is just asking for trouble.  All bets are off - the kernel _will_
> corrupt your data stream in random places.
>
> Don't do it - it will _NEVER_ be reliable.
>
> Never, ever, mix kernel consoles with application serial ports.
>
> --
> Russell King
>  Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
>  maintainer of:
>


-- 
EvoLogics GmbH
Blumenstraﬂe 49, 10243 Berlin

F&E Labor Bionik
Ackerstraﬂe 76, 13355 Berlin

Tel.: + 49- (0) 30- 46 06 82 26
Fax:  + 49- (0) 30- 46 06 82 15

lesha@evologics.de
