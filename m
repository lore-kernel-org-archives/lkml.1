Return-Path: <linux-kernel-owner+w=401wt.eu-S932441AbXGWX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441AbXGWX1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbXGWX1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:27:04 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42891
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbXGWX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:27:03 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Greg KH <greg@kroah.com>
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Date: Mon, 23 Jul 2007 19:26:54 -0400
User-Agent: KMail/1.9.6
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
References: <200707171703.31340.rob@landley.net> <200707202021.40009.rob@landley.net> <20070721004348.GA14362@kroah.com>
In-Reply-To: <20070721004348.GA14362@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707231926.55067.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 8:43:49 pm Greg KH wrote:
> On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:
> > Ok, back up.  /sys/devices does not contain all the information necessary
> > to populate /dev, because it hasn't got things like
> > ramdisks, /dev/zero, /dev/console which are THERE in sysfs, which may or
> > may not be supported by the kernel (the kernel might have ramdisk
> > support, might not).
>
> Welcome to 2007:
>
> $ ls /sys/devices/virtual/mem/
> full  kmem  kmsg  mem  null  port  random  urandom  zero
> $ ls /sys/devices/virtual/tty/
> console  tty12  tty19  tty25  tty31  tty38  tty44  tty50  tty57  tty63
> ptmx     tty13  tty2   tty26  tty32  tty39  tty45  tty51  tty58  tty7
> tty      tty14  tty20  tty27  tty33  tty4   tty46  tty52  tty59  tty8
> tty0     tty15  tty21  tty28  tty34  tty40  tty47  tty53  tty6   tty9
> tty1     tty16  tty22  tty29  tty35  tty41  tty48  tty54  tty60
> tty10    tty17  tty23  tty3   tty36  tty42  tty49  tty55  tty61
> tty11    tty18  tty24  tty30  tty37  tty43  tty5   tty56  tty62
>
> I suggest you take a close look at the kernel before making statements
> like the above :)

I did:

landley@dell:/sys/devices$ ls /sys/devices/virtual
ls: /sys/devices/virtual: No such file or directory
landley@dell:/sys/devices$ cat /proc/version
Linux version 2.6.20-16-generic (root@terranova) (gcc version 4.1.2 (Ubuntu 
4.1.2-0ubuntu4)) #2 SMP Thu Jun 7 20:19:32 UTC 2007

I.E. Ubuntu 7.04, stock.  The most recent release, using a 2.6.20 kernel.

I see that what you're talking about is in 2.6.22.  Back when I started 
writing my document in May, I forgot to check 2.6.22.

> > These things could also, in future, have their major and minor numbers
> > dynamically (even randomly) assigned.  That's been discussed on this
> > list.
>
> I tried that once, it will require some core api kernel changes and a
> lot of infrastrucure work to get that to work properly.  Not that it
> will never happen in the future, but it's just not a trivial change at
> the moment...

Understood.

> thanks,
>
> greg k-h

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
