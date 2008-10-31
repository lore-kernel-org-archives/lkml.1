Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbYJaJQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbYJaJQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbYJaJQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:16:30 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:57060 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbYJaJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:16:29 -0400
Date: Fri, 31 Oct 2008 10:16:27 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library
In-Reply-To: <20081031073507.GB18182@logfs.org>
Message-ID: <Pine.LNX.4.64.0810311016160.22521@anakin>
References: <20081026124643.GA1328@logfs.org> <20081030174300.GA1773@ucw.cz>
 <20081030175844.GC7157@logfs.org> <200810310738.46326.borntraeger@de.ibm.com>
 <20081031073507.GB18182@logfs.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463808415-883735743-1225444587=:22521"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463808415-883735743-1225444587=:22521
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 31 Oct 2008, Jörn Engel wrote:
> On Fri, 31 October 2008 07:38:46 +0100, Christian Borntraeger wrote:
> > Am Donnerstag, 30. Oktober 2008 schrieb Jörn Engel:
> > > Except that min/max in include/linux/kernel.h have some type-safety
> > > added.  In this particular case that is actually a disadvantage:
> > 
> > So what about min_t and max_t from include/linux/kernel.h? Can that be used?
> 
> Sorry, no.  The problems comes from using MAX in structure initializers.
> 
> struct btree_geo btree_geo32 = {
> 	.keylen = 1,
> 	.no_pairs = NODESIZE / sizeof(long) / 2,
> };

Where's the MIN/MAX? ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
---1463808415-883735743-1225444587=:22521--
