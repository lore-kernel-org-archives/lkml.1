Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZHHSy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZHHSy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 14:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZHHSy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 14:54:56 -0400
Received: from mailhost3.gawab.com ([66.220.20.3]:37185 "HELO info8.gawab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751144AbZHHSy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 14:54:56 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based /dev
Date: Sat, 8 Aug 2009 21:55:24 +0300
User-Agent: KMail/1.5
Cc: Chris Friesen <cfriesen@nortel.com>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
References: <20090805171513.GA10443@kroah.com> <200908081214.39456.a1426z@gawab.com> <20090808171124.GA357@kroah.com>
In-Reply-To: <20090808171124.GA357@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908082155.24686.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Aug 08, 2009 at 12:14:39PM +0300, Al Boldi wrote:
> > Greg KH wrote:
> > > On Sat, Aug 08, 2009 at 12:17:31AM +0300, Al Boldi wrote:
> > > > For devtmpfs to be a realistic replacement for static /dev, it has to
> > > > be comparable to static /dev in both speed and size.
> > >
> > > Since when is this requirement necessary?  You want something for free
> > > in both speed and size?  Well, you got it in speed, but not size, it
> > > will take up memory that is swapable, and a tiny ammount of
> > > non-swapable kernel memory for the code.
> >
> > Not so tiny when you count in the hotplug dependency.
>
> devtmpfs does not rely on hotplug at all.

Are you sure?

This is from the patch of this thread:
> +config DEVTMPFS
> +       bool "Create a kernel maintained /dev tmpfs (EXPERIMENTAL)"
> +       depends on HOTPLUG && SHMEM && TMPFS


Thanks!

--
Al

