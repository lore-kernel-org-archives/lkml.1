Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZHFR0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZHFR0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755959AbZHFR0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:26:36 -0400
Received: from mailhost5.gawab.com ([66.220.20.5]:48812 "HELO info14.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755896AbZHFR0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:26:36 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based  /dev
Date: Thu, 6 Aug 2009 20:27:09 +0300
User-Agent: KMail/1.5
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908062006.16263.a1426z@gawab.com> <ac3eb2510908061015p1c7fd544hc8d8e5bdac738c08@mail.gmail.com>
In-Reply-To: <ac3eb2510908061015p1c7fd544hc8d8e5bdac738c08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908062027.09413.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Thu, Aug 6, 2009 at 19:06, Al Boldi<a1426z@gawab.com> wrote:
> > Andi Kleen wrote:
> >> Greg KH <greg@kroah.com> writes:
> >> > It makes the userspace boot process much simpler and easier to
> >> > maintain, as well as providing a way to handle rescue disks and images
> >> > trivially, and it makes the kernel _less_ dependant on the early
> >> > userspace bootup scripts.
> >>
> >> As a initrd less kernel user I can really only agree: getting rid
> >> of the udev-in-initrd requirement would be a big step forward
> >> in usability. Typically I always have to pre populate
> >> a on disk /dev manually first to get my kernels to boot.
> >
> > Oh good, I thought I was the only one doing that.
> >
> > The reason I don't like udev is that it's just to slow; something like a
> > 5-10s delay on each boot.  No idea why it should be so slow,
>
> Because you setup is broken, I guess.
>
> > but it's probably
> > probing the kernel for all available devices at boot, when it could be
> > much quicker by probing for the device on access.
>
> It takes more like 0.5 - 0.7 seconds on a usual setup.

I don't know about your setup, but all dists I used (fedora, mandriva, ubuntu, 
debian) hang every boot for 5-10s.

Are you saying devtmpfs has the same delay as udev?

Thanks!

--
Al

