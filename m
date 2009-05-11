Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbZEKVTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbZEKVTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:19:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756450AbZEKVTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:19:24 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:32836 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754461AbZEKVTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:19:24 -0400
Date: Mon, 11 May 2009 22:19:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [patch 00/13] devtmpfs patches
Message-ID: <20090511221947.50eda8d5@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<1242063630.6624.22.camel@moss-terrapins.epoch.ncsc.mil>
	<20090511175626.GA4758@kroah.com>
	<1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> By doing its own fstype, we could also make the auto-mount optional,
> because you could always reach the filesystem anytime later.

Killing the automount would also fix a lot of the other problems as you
can then mount it in the initrd and dump it when you have the real fs up,
or you can mount it privately thanks to Al Viro's magic with mount points
and only the daemon that must make the "real" device file system need
have it mounted and accessible.

> A different fstype has the slight inconvenience, that existing
> userspace needs to be taught to handle it explicitly, while a tmfps is
> already handled automatically because we use tmpfs already today. But
> that may not be too important.

Thats a good thing - it stops some of the suprise behaviour the Eric
pointed out and objected to.

> Thanks a lot for your tests and analysis,

And I think btw the underlying failure was in the tty layer - I just need
to find it. It's the second report vaguely of this form so something is
lurking in the stygian depths.

Alan
