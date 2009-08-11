Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbZHKPSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbZHKPSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbZHKPSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:18:07 -0400
Received: from mailhost5.gawab.com ([66.220.20.5]:42106 "HELO info14.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755246AbZHKPSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:18:03 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Tue, 11 Aug 2009 18:18:16 +0300
User-Agent: KMail/1.5
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908110648.26191.a1426z@gawab.com> <20090811040431.GA1178@kroah.com>
In-Reply-To: <20090811040431.GA1178@kroah.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908111818.16399.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 11, 2009 at 06:48:26AM +0300, Al Boldi wrote:
> > Linux used to be lean and mean which made it fun to work with, and which
> > made the switch from the competition easy.  Nowadays I see a lot of bloat
> > going into the kernel which may indicate that Linux is starting to run
> > out of steam.
>
> That doesn't seem to make sense, if more development is happening, and
> our number of contributors, different companies, and rate of change is
> increasing, how are we "running out of steam"?

Running out of "quality steam".  Quantity can never replace Quality.

> What specific development number is proof of us slowing down?  I see
> nothing but the exact, and extreme, opposite thing happening.

The increasing number of regressions are probably cause for concern.

> > devtmpfs seems bloaty due to the hotplug dependency.
>
> Would you use it if we fix it to remove this dependancy?

Yes, if it also compares to static /dev in terms of speed.

> So what really is your objection here?  That we did not let devtmpfs
> work within a CONFIG_HOTPLUG=n type system? 

Yes.

> Or that devtmpfs works with
> the existing CONFIG_HOTPLUG=y systems (i.e. 99% of the world)?

And that should stay an option.


Thanks!

--
Al

