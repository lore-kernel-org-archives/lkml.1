Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZGJVND@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZGJVND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:13:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZGJVMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:12:53 -0400
Received: from mail2.shareable.org ([80.68.89.115]:49041 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZGJVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:12:52 -0400
Date: Fri, 10 Jul 2009 22:12:34 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: tridge@samba.org, Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710211234.GA30322@shareable.org>
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <200907081339.59815.Martin@lichtvoll.de> <19029.28240.995268.850038@samba.org> <20090710073654.GB28106@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710073654.GB28106@elf.ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> > I tested it with dosfstools (which provides the fsck.vfat on Linux
> > distros) and with mtools. Both required patches to work correctly. I
> > have submitted both patches to the maintainers of those packages.
> 
> Yes... so we know that your patch breaks at least
> 
...
> linux (patches available).

Ew.

Old Linux boxes don't get updates, and they don't have udev, hotplug
or auto-mounting desktops either.  They're the ones where mtools is
used on floppies.

-- Jamie
