Return-Path: <linux-kernel-owner+w=401wt.eu-S1755646AbZGALZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646AbZGALZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbZGALYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:24:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52246 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755562AbZGALYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:24:53 -0400
Date: Wed, 1 Jul 2009 12:25:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pavel Machek <pavel@ucw.cz>, tridge@samba.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
In-Reply-To: <200907012019.53932.rusty@rustcorp.com.au>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd actually prefer to see the code ripped out and no config option available; 
> it would the clearest avoidance case possible.

What about the free world - why should we suffer because Americans have
a broken patent system ? That just leads to a Farenheit 451 model where
the kernel sources end up containing no code, text or image that can
offend, harm or be found wanting in any possible legal jurisdiction.

If we put in VFAT american fixes presumably we need to put in monitoring
features required by dubious governments ?

If you want to rip stuff out of your copy feel free. I am quite sure many
US based vendors will do that (because they do so already with things
like video codecs rather than just disabling the build option).

Also please stop calling it VFAT. With the changes made it isn't VFAT and
it's misleading to an end user to advertise it as vfat and users
shouldn't accidentally be able to specify -o vfat and get non-vfat. Thats
asking for incompatibility, data loss and unpleasant unwarned of suprises.

Its "linfat" or something which when you've fixed the bugs Pavel has
pointed out might be semi-compatible with other products (most *FAT using
products don't use Microsofts implementation). Testing it versus Windows
and saying it works is not really adequate. Thats what ACPI and BIOS
people do that *we* moan about all the time.

Alan
