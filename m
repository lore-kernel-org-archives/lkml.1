Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbZHGVSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbZHGVSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZHGVSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:18:13 -0400
Received: from mailhost14.gawab.com ([66.220.20.14]:35930 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755437AbZHGVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:18:12 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: "Chris Friesen" <cfriesen@nortel.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Sat, 8 Aug 2009 00:17:31 +0300
User-Agent: KMail/1.5
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <20090807052015.GA24615@kroah.com> <4A7C4D6C.6050101@nortel.com>
In-Reply-To: <4A7C4D6C.6050101@nortel.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908080017.31376.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Friesen wrote:
> Greg KH wrote:
> > On Fri, Aug 07, 2009 at 08:04:08AM +0300, Al Boldi wrote:
> >> The question is, how fast can devtmpfs get the device list from the
> >> kernel on bootup?  How much faster than udev?  How much slower than
> >> static /dev?
> >
> > It's much faster than udev, and is equivalent to a static /dev with the
> > exception that the group and permission settings that you are used to.
> > udev then needs to come along and make those settings, but that's so
> > frickin fast it's amazing.
>
> Earlier in the thread you indicated a 0.5sec speedup over udev.  Is that
> really considered "much faster"?
>
> I do agree that it makes sense to do this, but more from an elegance
> view than a performance one.

It's definitely more elegant, but at what cost?

For devtmpfs to be a realistic replacement for static /dev, it has to be 
comparable to static /dev in both speed and size.  WRT speed, there should be 
no  slowdown and it should be just as fast as a "tar -xp < dev.tar".  WRT 
size, it should not be dependent on hotplug, and instead offer hotplug as an 
option.


Thanks!

--
Al

