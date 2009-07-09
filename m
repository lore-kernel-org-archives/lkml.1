Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbZGIEyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbZGIEyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZGIExz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:53:55 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:43506 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZGIExw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:53:52 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, tridge@samba.org,
       Martin Steigerwald <Martin@lichtvoll.de>,
       Jan Engelhardt <jengelh@medozas.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
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
Date: Thu, 09 Jul 2009 13:53:38 +0900
In-Reply-To: <20090708171848.21633768@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Wed, 8 Jul 2009 17:18:48 +0100")
Message-ID: <873a96a23x.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> Sure and I'd say the technical issues are simple
>
> - Tridge's patch breaks stuff
> - Tridge's patch masquerades as vfat but isn't.
>
> We can fix those by only creating short names (but honouring existing
> long ones) and by not claiming its vfat.

As technical stand, I agree with this approach. And my poor brain can't
consider other than technical thing, it is purely my problem though. So
I'll try to create the patch based on first version, and I'll apply it
instead.

And could you please stop talking about other than technical issues? My
poor brain is already overflowed.

I'm a fool?  Yes, I agree.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
