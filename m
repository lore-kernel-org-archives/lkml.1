Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYIKI3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYIKI3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 04:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYIKI3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 04:29:39 -0400
Received: from divinity.tty.gr ([212.89.179.170]:48940 "EHLO mail.tty.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYIKI3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 04:29:38 -0400
Message-ID: <48C8D707.6090801@debian.org>
Date: Thu, 11 Sep 2008 11:29:59 +0300
From: Faidon Liambotis <paravoid@debian.org>
Organization: Debian
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Marcel Holtmann <holtmann@linux.intel.com>
CC: David Miller <davem@davemloft.net>, dwmw2@infradead.org, jeffm@suse.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] firmware: Allow release-specific firmware dir
References: <1221087719.13621.50.camel@macbook.infradead.org>	 <20080910.160505.14060698.davem@davemloft.net>	 <1221088512.13621.58.camel@macbook.infradead.org>	 <20080910.162423.40167601.davem@davemloft.net> <1221119068.6309.8.camel@californication>
In-Reply-To: <1221119068.6309.8.camel@californication>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> it is that the Debian maintainer screwed this up. Upstream never
> promoted kernel versioned directories for the firmware. I had a long
> discussion with Dave about it at OLS and using the kernel version is
> just plain wrong. The driver maintainers should version the firmware if
> they break it in an API incompatible way.
> 
> To shed some light into the problem with Debian/Ubuntu. They install the
> firmware in /lib/firmware/`uname -r`/ and everytime they bump their ABI
> number, they have to install all the firmware again. This is just
> braindead. Their udev script actually checks /lib/firmware first and
> then the kernel versioned directory. So that is just fine.
I could not find any packages in Debian that contain a
/lib/firmware/$(KERNELRELEASE) directory.

Perhaps this is just an Ubuntu issue?

Regards,
Faidon

