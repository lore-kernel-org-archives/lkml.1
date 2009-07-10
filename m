Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbZGJV3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbZGJV3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbZGJV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:29:08 -0400
Received: from mail2.shareable.org ([80.68.89.115]:51724 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbZGJV3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:29:06 -0400
Date: Fri, 10 Jul 2009 22:28:53 +0100
From: Jamie Lokier <jamie@shareable.org>
To: tridge@samba.org
Cc: Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Message-ID: <20090710212853.GB30322@shareable.org>
References: <19013.8005.541836.436991@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <200907081339.59815.Martin@lichtvoll.de> <19029.28240.995268.850038@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19029.28240.995268.850038@samba.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tridge@samba.org wrote:
> I haven't tested against w2k yet. I'll need to dig through my old MSDN
> CD stack and see if I can find a w2k CD to test with. It's no longer
> offered on current MSDN subscriptions.

Windows NT-derivatives and Windows 95-derivatives use a significantly
different code base for their filesystems, even to the extent of
having different VFAT behaviour.  Hence shortnames=win95, shortname=winnt.

The last Windows 95-derivative is Windows ME, which is was released
about the same time as Windows 2000.  Windows 2000 is an NT-derivative.

So it might be worth testing against Windows ME.

I don't know what code base is used for Windows CE.  CE is still used,
on phones, PDAs and media players among other things.  Has there been
any testing against CE - current versions and old versions?

-- Jamie
