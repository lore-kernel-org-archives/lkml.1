Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZGFNTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZGFNTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZGFNTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:19:04 -0400
Received: from mail.samba.org ([66.70.73.150]:58879 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbZGFNTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:19:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19025.63119.656216.431469@samba.org>
Date: Mon, 6 Jul 2009 23:05:19 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
	<alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr>
	<19021.19842.663727.146474@samba.org>
	<87hbxu60qm.fsf@devron.myhome.or.jp>
	<19021.23231.213863.726785@samba.org>
	<alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
	<19021.26102.80885.330380@samba.org>
	<alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr>
	<19021.31291.642416.956966@samba.org>
	<alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr>
	<19021.63615.450348.192109@samba.org>
	<alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > With this extra patch:
 > 
 >  * "cp dscf4160.jpg dscf3010.jpg" works

good

 >  * "cp dscf4160.jpg dscF3011.jpg" does not work - i.e. cam ignores the
 >    file without error.
 >    Reason for that is that dscF3011 has an illegal 8.3 name

yep, that's expected. I suggested a possible way of handling this to
Hirofumi-san (ie. change the case of the name), but he prefers to keep
things simple for now.

It is probably not unreasonable to say that you should not be using
mixed case names when you are putting files onto a device that doesn't
understand mixed case. The reason it worked before my patch is that
the kernel forced the case of the 8.3 name, and only retained the
mixed case for the long name.

How did things go with your mp3 players?

Cheers, Tridge
