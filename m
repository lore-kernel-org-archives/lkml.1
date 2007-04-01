Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXDASB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXDASB6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933755AbXDASB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:01:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45767 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933751AbXDASB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:01:57 -0400
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
From: David Zeuthen <davidz@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <20070401175020.GE11146@elf.ucw.cz>
References: <200703271824.46804.maximlevitsky@gmail.com>
	 <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
	 <20070327110524.975e7113.zaitcev@redhat.com>
	 <200703280129.10197.maximlevitsky@gmail.com> <20070401152957.GA5068@ucw.cz>
	 <1175449366.3008.120.camel@zelda.fubar.dk>
	 <20070401175020.GE11146@elf.ucw.cz>
Content-Type: text/plain
Date: Sun, 01 Apr 2007 14:01:30 -0400
Message-Id: <1175450490.3008.128.camel@zelda.fubar.dk>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 19:50 +0200, Pavel Machek wrote:
> Problem is that suspending _with_ removable mass storage devices
> attached just will not work. User will unplug them, then complain
> about corruption. Advanced user will unplug them, work with them
> somewhere else, replug them, then loose filesystem.
> 
> Feel free to send patch to teach filesystems to handle this.

I was suggesting in the Bugzilla that the file system should actually do
this. I don't have a patch for this, sorry. 

> Check your facts. Laptops do not melt. I know, I put them into my bed,
> covered with pillow, and let them complain (evo 560c). ACPI thermals
> can handle that.

Some laptops may severely overheat especially if the backlight is not
turned off (See: Apple hardware). Pretending that all hardware "just
works" or that all drivers "just work" is nice but not really useful in
the real life especially when we're talking about damaging hardware.

     David


