Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbXJJIhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbXJJIhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 04:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXJJIhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 04:37:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:18509 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbXJJIhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 04:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jdEIcGh769wWDL1D8/ULz62sed0dZNoG4fsMPDCnrdrXqpk8aWjOh4tmhP08fahMY/sma7bDjSU+vNMbnjKXIUR8mCegVU9Ca6jP8jOLkmTDXbadfDAdlBQ2rcA2djkL+pG/7Rt6T9cIOK6ozkNyU7LfS5t250Xj0Elr4W68URg=
Message-ID: <b6fcc0a0710100137l7deb2547h8cbd48f38b4d3417@mail.gmail.com>
Date: Wed, 10 Oct 2007 12:37:22 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "=?ISO-8859-1?Q?Ren=E9_Rebe?=" <rene@exactcode.de>
Subject: Re: Linux 2.6.23
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200710100944.16378.rene@exactcode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
	 <200710100944.16378.rene@exactcode.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/07, René Rebe <rene@exactcode.de> wrote:
> 2.6.23 does not build with my usual .config on x86_64 and gcc-4.2.1:
>
> In file included from fs/drop_caches.c:8:
> include/linux/mm.h:1210: warning: 'struct super_block' declared inside
> parameter list

> --- linux-2.6.23/include/linux/mm.h.vanilla
> +++ linux-2.6.23/include/linux/mm.h

> +struct super_block;
>  extern void drop_pagecache_sb(struct super_block *);
>  void drop_pagecache(void);
>  void drop_slab(void);
>
> You probably end up fixing it some other way, but as I do not know this
> file inside out I just wanted to drop a note.

You have some strange vanilla kernel. 2.6.23 doesn't have this prototype.
