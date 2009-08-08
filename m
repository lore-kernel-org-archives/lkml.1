Return-Path: <linux-kernel-owner+w=401wt.eu-S933792AbZHHJOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933792AbZHHJOH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 05:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933729AbZHHJOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 05:14:06 -0400
Received: from mailhost14.gawab.com ([66.220.20.14]:60269 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933723AbZHHJOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 05:14:05 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Sat, 8 Aug 2009 12:14:39 +0300
User-Agent: KMail/1.5
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908080017.31376.a1426z@gawab.com> <20090807222449.GA31416@kroah.com>
In-Reply-To: <20090807222449.GA31416@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908081214.39456.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> > For devtmpfs to be a realistic replacement for static /dev, it has to
> > be comparable to static /dev in both speed and size.
>
> Since when is this requirement necessary?  You want something for free
> in both speed and size?  Well, you got it in speed, but not size, it
> will take up memory that is swapable, and a tiny ammount of non-swapable
> kernel memory for the code.

Not so tiny when you count in the hotplug dependency.

> > WRT speed, there should be no  slowdown and it should be just as fast
> > as a "tar -xp < dev.tar".
>
> Again, where is this requirement coming from?
>
> Have you timed devtmpfs?

Not yet, I am still waiting for the latest patch against .30.

> > WRT size, it should not be dependent on hotplug, and instead offer
> > hotplug as an option.
>
> Um, again, who made up such a requirement?  Are you running systems
> today with CONFIG_HOTPLUG disabled?  If so, how well is that working for
> you?

It's working out quite well.  I don't like hotplug, it's too slow.  I always 
turn it and module-autoloading off, to achieve a much more responsive system.


Thanks!

--
Al

