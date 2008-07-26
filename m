Return-Path: <linux-kernel-owner+w=401wt.eu-S1757859AbYGZUd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859AbYGZUd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 16:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbYGZUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 16:33:21 -0400
Received: from ns2.avonet.cz ([217.112.162.42]:40435 "EHLO ns2.avonet.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755203AbYGZUdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 16:33:20 -0400
X-Greylist: delayed 2398 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 16:33:20 EDT
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
From: Petr =?ISO-8859-1?Q?Stehl=EDk?= <pstehlik@sophics.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       =?UTF-8?Q?=EF=BF=BD?= <rene.scharfe@lsrfire.ath.cx>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0807261724400.16910@anakin>
References: <1211717062.5782.16.camel@ubuntu>
	 <87ve12s849.fsf@duaron.myhome.or.jp> <20080601221035.GA9107@nineveh.local>
	 <87zlq4rd30.fsf@duaron.myhome.or.jp>
	 <Pine.LNX.4.64.0806020930170.7351@anakin> <4843D179.7070809@sophics.cz>
	 <87od6jop4j.fsf@duaron.myhome.or.jp>
	 <Pine.LNX.4.64.0807261724400.16910@anakin>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Jul 2008 21:53:04 +0200
Message-Id: <1217101984.6302.10.camel@joy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven píše v So 26. 07. 2008 v 17:28 +0200:
> > > The patch looks good, how can I let it live?
> > 
> > Could you test whether it works well? If it works fine, I'll merge and
> > clean it up. If it doesn't work, please fix it.
> 
> Petr, as there has been no further response anymore, it went into Linus' tree:

I know I should have checked that but I have been so overloaded at my
regular job that I couldn't do anything with my FOSS projects or Atari,
sorry.

> I'm inclined to drop it, if nobody seems to really care...

I can't care currently so feel free to drop it.

> > BTW,
> > 
> > +		if (sbi->fat_bits != 32 && total_clusters+2 > sbi->
> > +			fat_length*SECTOR_SIZE*8/sbi->fat_bits)
> > +			sbi->fat_bits = 12;
> > 
> > SECTOR_SIZE should be sb->s_blocksize? Or Atari doesn't support the
> > sector size other than 512 bytes?

I haven't seen floppies with > 512 sectors. Atari partitioned harddisks
use ﻿much larger sectors (up to 32 kB), ﻿of course.

Petr


