Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbXJJJMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbXJJJMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbXJJJMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 05:12:33 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21207 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbXJJJMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 05:12:33 -0400
Message-ID: <470C977E.6010704@msgid.tls.msk.ru>
Date: Wed, 10 Oct 2007 13:12:30 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: =?ISO-8859-1?Q?Ren=E9_Rebe?= <rene@exactcode.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>	 <200710100944.16378.rene@exactcode.de> <b6fcc0a0710100137l7deb2547h8cbd48f38b4d3417@mail.gmail.com>
In-Reply-To: <b6fcc0a0710100137l7deb2547h8cbd48f38b4d3417@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On 10/10/07, René Rebe <rene@exactcode.de> wrote:
>> 2.6.23 does not build with my usual .config on x86_64 and gcc-4.2.1:
>>
>> In file included from fs/drop_caches.c:8:
>> include/linux/mm.h:1210: warning: 'struct super_block' declared inside
>> parameter list
> 
>> --- linux-2.6.23/include/linux/mm.h.vanilla
>> +++ linux-2.6.23/include/linux/mm.h
> 
>> +struct super_block;
>>  extern void drop_pagecache_sb(struct super_block *);
>>  void drop_pagecache(void);
>>  void drop_slab(void);
>>
>> You probably end up fixing it some other way, but as I do not know this
>> file inside out I just wanted to drop a note.
> 
> You have some strange vanilla kernel. 2.6.23 doesn't have this prototype.

The same happens here as well.

-rw-rw-r--  1 mjt mjt 45488158 Oct  9 20:48 linux-2.6.23.tar.bz2
2cc2fd4d521dc5d7cfce0d8a9d1b3472  linux-2.6.23.tar.bz2

(timestamp is in UTC) Downloaded yesterday, 3 hours after an announce,
from http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2 .

/mjt
