Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXJJKgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXJJKgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 06:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXJJKge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 06:36:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:26957 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbXJJKgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 06:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IJ9R2J7IeCl2XT/EAKNkgsM3EJ7cxK8qCTCKc4xpnb5bcQ5jEC7Ainva7Q3VV4dkhYQn70j/33xDq/N26useKAL/tcS+vEveW78nANIdyCntbAEnRV4zu33RNSAZ7+QUfZ6Zwjx3+APNx91MUb8h4jDEgKvFd/KhpLEj8QwF5mA=
Message-ID: <b6fcc0a0710100336t679b881es644aa4c27a3ce4fc@mail.gmail.com>
Date: Wed, 10 Oct 2007 14:36:31 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: Linux 2.6.23
Cc: "=?ISO-8859-1?Q?Ren=E9_Rebe?=" <rene@exactcode.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <470C977E.6010704@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
	 <200710100944.16378.rene@exactcode.de>
	 <b6fcc0a0710100137l7deb2547h8cbd48f38b4d3417@mail.gmail.com>
	 <470C977E.6010704@msgid.tls.msk.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
> Alexey Dobriyan wrote:
> > On 10/10/07, René Rebe <rene@exactcode.de> wrote:
> >> 2.6.23 does not build with my usual .config on x86_64 and gcc-4.2.1:
> >>
> >> In file included from fs/drop_caches.c:8:
> >> include/linux/mm.h:1210: warning: 'struct super_block' declared inside
> >> parameter list
> >
> >> --- linux-2.6.23/include/linux/mm.h.vanilla
> >> +++ linux-2.6.23/include/linux/mm.h
> >
> >> +struct super_block;
> >>  extern void drop_pagecache_sb(struct super_block *);
> >>  void drop_pagecache(void);
> >>  void drop_slab(void);
> >>
> >> You probably end up fixing it some other way, but as I do not know this
> >> file inside out I just wanted to drop a note.
> >
> > You have some strange vanilla kernel. 2.6.23 doesn't have this prototype.
>
> The same happens here as well.
>
> -rw-rw-r--  1 mjt mjt 45488158 Oct  9 20:48 linux-2.6.23.tar.bz2
> 2cc2fd4d521dc5d7cfce0d8a9d1b3472  linux-2.6.23.tar.bz2
>
> (timestamp is in UTC) Downloaded yesterday, 3 hours after an announce,
> from http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.23.tar.bz2 .

Strange. Same size, same md5, no super_block in mm.h, though
