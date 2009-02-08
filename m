Return-Path: <linux-kernel-owner+w=401wt.eu-S1753279AbZBHJoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbZBHJoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 04:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbZBHJn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 04:43:56 -0500
Received: from sov-mail-b0023.gradwell.net ([193.84.87.47]:42214 "EHLO
	sov-mail-b0023.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752774AbZBHJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 04:43:55 -0500
Date: Sun, 8 Feb 2009 09:43:33 +0000
From: Alex Buell <alex.buell@munted.org.uk>
To: A B <spinflipper4@yahoo.co.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: Fat64 / exFat fs and Linux
Message-ID: <20090208094333.490abcc1@lithium.local.net>
In-Reply-To: <473359.26476.qm@web25803.mail.ukl.yahoo.com>
References: <54747.12003.qm@web25801.mail.ukl.yahoo.com>
	<871vul3g14.fsf@devron.myhome.or.jp>
	<49822E2A.3020601@zytor.com>
	<957266.96237.qm@web25805.mail.ukl.yahoo.com>
	<87bptp1njj.fsf@devron.myhome.or.jp>
	<87bptouoid.fsf@devron.myhome.or.jp>
	<473359.26476.qm@web25803.mail.ukl.yahoo.com>
Organization: One tortoiseshell cat, very high maintenance
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
X-Face: "wUuhsy:X)M;>-dA\j"&y@*\$91]iX10Iv1WG_oNbGYpo,eqc06O?"VSeRTx]xM\LiITUh01z}<|GF/4Gzz(MAU~;p4AS,%TB69M:vB-9+i'#W7$UQCW&UP#zt{VdLlzEiw8k~jL<
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Feb 2009 12:46:00 +0000 (GMT), I waved a wand and this
message magically appears in front of A B:

> > I've updated the tarballs to fix the bug he found. If someone tried
> > old tarballs, please download new tarballs and try.
> > 
> >     http://userweb.kernel.org/~hirofumi/exfat/exfat.tar.gz

I have just converted your set of patches into a standalone module
driver that you can build outside the kernel as long as you have a
recent version of the kernel sources installed (currently 2.6.27). 

The only modification I needed to make was to add an extern for sys_tz
in utils.c (extern struct timezone sys_tz)

The bz2 tarball can be found at:
http://www.munted.org.uk/programming/exfat.tar.bz2

Regards,
Alex
-- 
http://www.munted.org.uk

Fearsome grindings.
