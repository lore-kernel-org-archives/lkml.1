Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbYIKQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbYIKQM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 12:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYIKQMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 12:12:13 -0400
Received: from senator.holtmann.net ([87.106.208.187]:53101 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYIKQMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 12:12:12 -0400
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Faidon Liambotis <paravoid@debian.org>
Cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <48C8D707.6090801@debian.org>
References: <1221087719.13621.50.camel@macbook.infradead.org>
	 <20080910.160505.14060698.davem@davemloft.net>
	 <1221088512.13621.58.camel@macbook.infradead.org>
	 <20080910.162423.40167601.davem@davemloft.net>
	 <1221119068.6309.8.camel@californication>  <48C8D707.6090801@debian.org>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 18:12:41 +0200
Message-Id: <1221149561.6309.33.camel@californication>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Faidon,

> > it is that the Debian maintainer screwed this up. Upstream never
> > promoted kernel versioned directories for the firmware. I had a long
> > discussion with Dave about it at OLS and using the kernel version is
> > just plain wrong. The driver maintainers should version the firmware if
> > they break it in an API incompatible way.
> > 
> > To shed some light into the problem with Debian/Ubuntu. They install the
> > firmware in /lib/firmware/`uname -r`/ and everytime they bump their ABI
> > number, they have to install all the firmware again. This is just
> > braindead. Their udev script actually checks /lib/firmware first and
> > then the kernel versioned directory. So that is just fine.
> I could not find any packages in Debian that contain a
> /lib/firmware/$(KERNELRELEASE) directory.
> 
> Perhaps this is just an Ubuntu issue?

I looked through my Debian boxes and you are right. Sorry for this. I
was under the assumption Ubuntu took the Debian package, but it seems
that they even modified that one. So this issue is than distros derived
from Ubuntu and _not_ Debian (unless udev is unmodified).

Regards

Marcel


