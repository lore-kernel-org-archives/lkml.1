Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYAVCQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYAVCQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 21:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbYAVCQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 21:16:40 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:55790 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYAVCQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 21:16:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WbOsW80JY2p0PxcPg5htA87U4SYNgKC2T0I0Z4cbaQyTsFIJpVDpGcTMP2NYvgMFURpiSDCtHKiD+X2/iPWK0KQxn1yi3n1uaVuuPcSuc29uYKx0RJKBRdvqMonAMU6GONOe5iNI+Ro/yJStvJ5cweAATl1ZX6kpTHiWSY5DeN4=
Message-ID: <9a8748490801211816y4bcd6fefqfb3f2c2af1bbe970@mail.gmail.com>
Date: Tue, 22 Jan 2008 03:16:38 +0100
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Anton Salikhmetov" <salikhmetov@gmail.com>
Subject: Re: [PATCH -v7 2/2] Update ctime and mtime for memory-mapped files
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, torvalds@linux-foundation.org,
       a.p.zijlstra@chello.nl, akpm@linux-foundation.org, protasnb@gmail.com,
       miklos@szeredi.hu, r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com,
       hch@infradead.org
In-Reply-To: <4df4ef0c0801211807m3c790a2n679f44f3dec6dc9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12009619562023-git-send-email-salikhmetov@gmail.com>
	 <12009619584168-git-send-email-salikhmetov@gmail.com>
	 <9a8748490801211740r5c764f6ev9c331479f63ef362@mail.gmail.com>
	 <4df4ef0c0801211751w39d7b9e5ne2e8b788051d3e3a@mail.gmail.com>
	 <4df4ef0c0801211807m3c790a2n679f44f3dec6dc9d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/01/2008, Anton Salikhmetov <salikhmetov@gmail.com> wrote:
> 2008/1/22, Anton Salikhmetov <salikhmetov@gmail.com>:
> > 2008/1/22, Jesper Juhl <jesper.juhl@gmail.com>:
> > > Some very pedantic nitpicking below;
> > >
...
>
> By the way, if we're talking "pedantic", then:
>
> >>>
>
> debian:/tmp$ cat c.c
> void f()
> {
>        for (unsigned long i = 0; i < 10; i++)
>                continue;
> }
> debian:/tmp$ gcc -c -pedantic c.c
> c.c: In function 'f':
> c.c:3: error: 'for' loop initial declaration used outside C99 mode
> debian:/tmp$
>

Well, I just wrote the way I'd have writen the loop, I know it's not
the common kernel style.  Just offering my feedback/input :)


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
