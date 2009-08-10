Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZHJMGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZHJMGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZHJMGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:06:52 -0400
Received: from mailhost3.gawab.com ([66.220.20.3]:35689 "HELO info8.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753868AbZHJMGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:06:51 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Mon, 10 Aug 2009 15:05:36 +0300
User-Agent: KMail/1.5
Cc: Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>
References: <20090805171513.GA10443@kroah.com> <200908062318.05478.a1426z@gawab.com> <1249894896.4431.6.camel@quest>
In-Reply-To: <1249894896.4431.6.camel@quest>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908101505.36414.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott James Remnant wrote:
> On Thu, 2009-08-06 at 23:18 +0300, Al Boldi wrote:
> > Maybe they are using the same trick as Ubuntu and Debian, as they run
> > udev in the background to hide the slowness.  Both Fedora and Mandriva
> > run udev in the foreground where the slowness is visible.
>
> Ubuntu does not run udev in the background.

I put a date timestamp at the beginning and end of the start command of 
init.d/udev, and when you stop and then start init.d/udev it shows a ~5s 
delay.  At boot I don't see this delay, but instead see the initial date 
stamp, then a flurry of parallel activity, then the final date stamp, which 
shows the ~5s delay.


Thanks!

--
Al
