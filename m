Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbYAGW2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbYAGW2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 17:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbYAGW2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 17:28:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:54376 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYAGW2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 17:28:22 -0500
Date: Mon, 7 Jan 2008 23:27:21 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Bodo Eggert <7eggert@gmx.de>, Christer Weinigel <christer@weinigel.se>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, Rene Herman <rene.herman@gmail.com>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
In-Reply-To: <4782A355.1070207@zytor.com>
Message-ID: <alpine.LSU.0.999.0801072316440.16143@be1.lrz>
References: <9BdU5-1YW-9@gated-at.bofh.it> <9BeZN-3Gf-5@gated-at.bofh.it>
 <9BnTB-1As-31@gated-at.bofh.it> <9BrX4-8go-1@gated-at.bofh.it>
 <9BuBG-4eR-51@gated-at.bofh.it> <9BvRd-6aL-71@gated-at.bofh.it>
 <9GRQW-1DX-13@gated-at.bofh.it> <9GSah-23W-1@gated-at.bofh.it>
 <9GSDy-2GD-23@gated-at.bofh.it> <9GTpK-40d-15@gated-at.bofh.it>
 <9GUvy-5H2-11@gated-at.bofh.it> <9GVKU-7SS-25@gated-at.bofh.it>
 <E1JBxnV-00046d-CS@be1.7eggert.dyndns.org> <478281A6.1000704@zytor.com>
 <alpine.LSU.0.999.0801072226060.16143@be1.lrz>
 <4782A355.1070207@zytor.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-2033884103-1199744841=:16143"
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/8mKtwhit7ZlxA5UV+3BzcihrRUX3/dR5132P
 QcSlIkl2YmdL+mf+qDHA3pn5YYr3ynbPbQmr9NDzK6v2ZCe33h
 R1ut7mOy5WKsgrNqYyrMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-2033884103-1199744841=:16143
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 7 Jan 2008, H. Peter Anvin wrote:
> Bodo Eggert wrote:

> > But overclocking is not the problem for udelay, it would err to the saf=
e
> > side. The problem would be a BUS having < 8 MHz, and since the days of
> > 80286, they are hard to find. IMO having an option to set the bus speed
> > for those systems should be enough.
> >=20
>=20
> There might have been a few 386/20's clocking the ISA bus at =AD=AD=F73
> (6.67 MHz) rather than =F72 (10 MHz) or =F72.5 (8 MHz).

Yes, and the remaining users should set the kernel option. Both of them.
The question is: How will they be told about the new kernel option?
--=20
A man inserted an advertisement in the classified: Wife Wanted."
The next day he received a hundred letters. They all said the
same thing: "You can have mine."
--8323584-2033884103-1199744841=:16143--
