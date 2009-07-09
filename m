Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbZGIE0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbZGIE0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZGIE0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:26:07 -0400
Received: from mail.samba.org ([66.70.73.150]:44291 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZGIE0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:26:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19029.29008.522539.547122@samba.org>
Date: Thu, 9 Jul 2009 14:25:52 +1000
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Rusty Russell <rusty@rustcorp.com.au>,
       Pavel Machek <pavel@ucw.cz>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <20090708171848.21633768@lxorguk.ukuu.org.uk>
References: <19013.8005.541836.436991@samba.org>
	<alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
	<19026.38137.63807.427511@samba.org>
	<200907072356.51553.Martin@lichtvoll.de>
	<19028.3736.892828.352905@samba.org>
	<20090708110451.1092afa7@lxorguk.ukuu.org.uk>
	<1247066878.4159.153.camel@mulgrave.site>
	<20090708163736.0f98e7e0@lxorguk.ukuu.org.uk>
	<1247069202.4159.212.camel@mulgrave.site>
	<20090708171848.21633768@lxorguk.ukuu.org.uk>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Can you explain what standard you think should be applied to patent
workaround patches for them to be acceptable? I'd like to know if
there is the possibility of us finding some agreement in the future or
not.

For example, some possibilities might be:

  1) no patent workarounds allowed in upstream kernel at all

  2) the workaround must be shown to have 100% compatibility with all
  current and possible future devices

  3) the workaround must be shown to have a high degree of
  compatibility with all the devices we have available to test with

  4) the workaround must have the highest degree of compatibility that
  we can achieve with the most used devices, but some degree of
  interoperability problems are OK for less used devices.

There are lots of possible levels in between these of course. I don't
think you are advocating (1) or (2), as you seem happier with the "no
long name creation" patch from May.

I also know you want whatever is done to be a different filesystem
name. 

I'm advocating (4) as a reasonable standard, although I'd like to
achieve (3) if we can. Whether we can actually achieve (3) will depend
on the results of further testing (see my messages to Jan on that for
example).

I apologise if you don't think this is a reasonable way to phrase the
question. As you are the most vocal opponent of the patch, I'd like to
better understand what it would take for you to find a patch
acceptable.

Cheers, Tridge
