Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbXJJKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbXJJKxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJJKxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:53:08 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:53368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbXJJKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:53:08 -0400
Date: Wed, 10 Oct 2007 12:53:06 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Michael Tokarev <mjt@tls.msk.ru>,
       =?ISO-8859-1?Q?Ren=E9_Rebe?= <rene@exactcode.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
In-Reply-To: <b6fcc0a0710100336t679b881es644aa4c27a3ce4fc@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0710101250520.22916@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
  <200710100944.16378.rene@exactcode.de>  <b6fcc0a0710100137l7deb2547h8cbd48f38b4d3417@mail.gmail.com>
  <470C977E.6010704@msgid.tls.msk.ru> <b6fcc0a0710100336t679b881es644aa4c27a3ce4fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 10 2007 14:36, Alexey Dobriyan wrote:
>> >> --- linux-2.6.23/include/linux/mm.h.vanilla
>> >> +++ linux-2.6.23/include/linux/mm.h
>> >
>> >> +struct super_block;
>> >>  extern void drop_pagecache_sb(struct super_block *);
>> >>  void drop_pagecache(void);
>> >>  void drop_slab(void);
>> >>
>> >> You probably end up fixing it some other way, but as I do not know this
>> >> file inside out I just wanted to drop a note.
>> >
>> > You have some strange vanilla kernel. 2.6.23 doesn't have this prototype.
>>
>> The same happens here as well.
>>
>> -rw-rw-r--  1 mjt mjt 45488158 Oct  9 20:48 linux-2.6.23.tar.bz2
>> 2cc2fd4d521dc5d7cfce0d8a9d1b3472  linux-2.6.23.tar.bz2
>>
>> (timestamp is in UTC) Downloaded yesterday, 3 hours after an announce,
>> from http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2 .
>
>Strange. Same size, same md5, no super_block in mm.h, though

Does someone still have the broken tarball?

There has not been any drop_pagecache_sb anytime between 2.6.23-rc1
and 2.6.23. drop_pagecache_sb reminds me of reiser4, too.
