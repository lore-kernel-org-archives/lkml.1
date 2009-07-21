Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbZGUKo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbZGUKo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbZGUKoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:44:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:51778 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbZGUKoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:44:24 -0400
Date: Tue, 21 Jul 2009 12:44:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Boaz Harrosh <bharrosh@panasas.com>
cc: tridge@samba.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Martin Steigerwald <Martin@lichtvoll.de>, Theodore Tso <tytso@mit.edu>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, torvalds@linux-foundation.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
In-Reply-To: <4A65875D.7030902@panasas.com>
Message-ID: <alpine.LSU.2.00.0907211236380.14924@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org> <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr> <19026.38137.63807.427511@samba.org> <200907072356.51553.Martin@lichtvoll.de> <19028.3736.892828.352905@samba.org> <20090708110451.1092afa7@lxorguk.ukuu.org.uk>
 <1247066878.4159.153.camel@mulgrave.site> <20090708163736.0f98e7e0@lxorguk.ukuu.org.uk> <1247069202.4159.212.camel@mulgrave.site> <20090708171848.21633768@lxorguk.ukuu.org.uk> <873a96a23x.fsf@devron.myhome.or.jp> <87hbxhwv0j.fsf@devron.myhome.or.jp>
 <19045.14307.658887.752950@samba.org> <4A65875D.7030902@panasas.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2009-07-21 11:16, Boaz Harrosh wrote:
>>   - Similarly, there is a small chance that chkdsk on Windows will
>>     rename one file in a directory if they happen to have the same 11
>>     byte dummy values. The probability of this happening is
>>     approximately 80x lower than with the previous patch.
>
>What if we had a user mode utility that does these short-names
>renames that a user can optionally run after umount? since it
>only writes the (random) short-names it's also safe.

Mm, user-mode. tridgefat could trigger a usermode process at open(2)
time to rebuild the short name with traditional semantics to counter
the 'breakage' induced by random 8.3 names.
