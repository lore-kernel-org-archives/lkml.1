Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738AbXJJLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbXJJLNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbXJJLNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 07:13:10 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:23685 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbXJJLNJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 07:13:09 -0400
Message-ID: <470CB3BF.2040904@msgid.tls.msk.ru>
Date: Wed, 10 Oct 2007 15:13:03 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       =?ISO-8859-1?Q?Ren=E9_Rebe?= <rene@exactcode.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>  <200710100944.16378.rene@exactcode.de>  <b6fcc0a0710100137l7deb2547h8cbd48f38b4d3417@mail.gmail.com>  <470C977E.6010704@msgid.tls.msk.ru> <b6fcc0a0710100336t679b881es644aa4c27a3ce4fc@mail.gmail.com> <Pine.LNX.4.64.0710101250520.22916@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0710101250520.22916@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Oct 10 2007 14:36, Alexey Dobriyan wrote:
>>>>> --- linux-2.6.23/include/linux/mm.h.vanilla
>>>>> +++ linux-2.6.23/include/linux/mm.h
>>>>> +struct super_block;
>>>>>  extern void drop_pagecache_sb(struct super_block *);
>>>>>  void drop_pagecache(void);
>>>>>  void drop_slab(void);
>>>>>
>>>>> You probably end up fixing it some other way, but as I do not know this
>>>>> file inside out I just wanted to drop a note.
>>>> You have some strange vanilla kernel. 2.6.23 doesn't have this prototype.
>>> The same happens here as well.
>>>
>>> -rw-rw-r--  1 mjt mjt 45488158 Oct  9 20:48 linux-2.6.23.tar.bz2
>>> 2cc2fd4d521dc5d7cfce0d8a9d1b3472  linux-2.6.23.tar.bz2
>>>
>>> (timestamp is in UTC) Downloaded yesterday, 3 hours after an announce,
>>> from http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2 .
>> Strange. Same size, same md5, no super_block in mm.h, though
> 
> Does someone still have the broken tarball?
> 
> There has not been any drop_pagecache_sb anytime between 2.6.23-rc1
> and 2.6.23. drop_pagecache_sb reminds me of reiser4, too.

ghhrm.  That's nonsense.  I found where that struct super_block come
from -- it's from unionfs patches for 2.6.22, which I forgot to
update for 2.6.23 (I just dropped new kernel tarball into my
build directory together with other patches and ran usual build
procedure).  It's a definitely false alarm - the tarball is
fine.

/mjt
