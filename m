Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZGFUg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZGFUg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZGFUgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:36:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:60414 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbZGFUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:36:41 -0400
Date: Mon, 6 Jul 2009 22:36:43 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <alpine.LSU.2.00.0907061932120.20434@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr> <19021.19842.663727.146474@samba.org> <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
 <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org>
 <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr> <19025.63119.656216.431469@samba.org> <alpine.LSU.2.00.0907061932120.20434@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-07-06 20:55, Jan Engelhardt wrote:
>>How did things go with your mp3 players?
>[...]
>As it stands, my two devices always want a valid 8.3 name.

On or about June 26, James Bottomley exchanged these words to Andrew Tridgell:
>So the patch has been tested with Vista, Windows 7 and Windows XP


Vista, 7... nothing special.

So let me fill in.

Windows 98 can't make anything of the stunted vfat entries either[3],
and there's blanks for 16-bit programs[4]. They too, it seems, always
want an 8.3 entry in any case.
It does not crash, but neither of these results is usable.

This dualnames patch just won't fly in practice.


[3] http://picpaste.de/w98dualnames.png
[4] http://picpaste.de/xpwith16bit.png
(pics kept for 7 days from now)
