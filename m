Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZGFLkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZGFLkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZGFLkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:40:40 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58311 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZGFLkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:40:39 -0400
Date: Mon, 6 Jul 2009 13:40:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: tridge@samba.org
cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Theodore Tso <tytso@mit.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <19021.63615.450348.192109@samba.org>
Message-ID: <alpine.LSU.2.00.0907061337550.9199@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <200907012019.53932.rusty@rustcorp.com.au> <20090701122558.3a7c80d3@lxorguk.ukuu.org.uk> <20090701140503.GA21185@mit.edu> <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.2.00.0907030134291.17183@fbirervta.pbzchgretzou.qr> <19021.19842.663727.146474@samba.org> <87hbxu60qm.fsf@devron.myhome.or.jp> <19021.23231.213863.726785@samba.org> <alpine.LSU.2.00.0907030347210.24650@fbirervta.pbzchgretzou.qr>
 <19021.26102.80885.330380@samba.org> <alpine.LSU.2.00.0907030403330.26905@fbirervta.pbzchgretzou.qr> <19021.31291.642416.956966@samba.org> <alpine.LSU.2.00.0907031121250.16093@fbirervta.pbzchgretzou.qr> <19021.63615.450348.192109@samba.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-03 14:24, tridge@samba.org wrote:
>Hi Jan,
>
> > Right. That in itself is fine, but I'd still like to have readdir
> > return lowercase names here then.
>
>you are in luck!

Dunno.
(It finally turns Monday...)

>I include it below. Can you please test it? It should be applied on
>top of the previous patch. Note that you will not need to specify
>shortname=winnt. In fact, if you don't specify any special options and
>let the kernel default then you will get the behaviour you just
>described.

With this extra patch:

 * "cp dscf4160.jpg dscf3010.jpg" works

 * "cp dscf4160.jpg dscF3011.jpg" does not work - i.e. cam ignores the
   file without error.
   Reason for that is that dscF3011 has an illegal 8.3 name
