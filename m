Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbXHBUKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbXHBUKR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758049AbXHBUKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:10:04 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:3520 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbXHBUKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:10:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Kh9t2L71e9+5st/Kpy94trvZj6CD6lv1fBD0IxNI0500x1jKYu4VGU3O4GfvdB/u63qfy4Gkqx25PanYq5z8wT1lfmh1Se1oZYX3maW+np09JGnb1GEgaCE2QiWJQTHe0K4UvM7j4hj+BPnsvkz+SA7S5vPZDe2EJIDDwRXoaok=
Message-ID: <9a8748490708021310q10f28c02ud1c9f8f95ff2869f@mail.gmail.com>
Date: Thu, 2 Aug 2007 22:10:02 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: error: implicit declaration of function 'rcu_dereference' - current -git fails to build
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>,
       "Jesper Juhl" <jesper.juhl@gmail.com>
In-Reply-To: <9a8748490708021257q2f28f8d5y4fdcebaca587fe8a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490708021257q2f28f8d5y4fdcebaca587fe8a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
> I get this build error with the current mainline git tree.

When I say "current mainline git tree" I mean that HEAD is at
370504cf7c68b953de55c41d5e0be97d30f3cf00

> Let me know if further details are needed...
>
> ...
> In file included from include/linux/sched.h:75,
>                  from include/linux/smp_lock.h:5,
>                  from include/linux/hardirq.h:5,
>                  from include/linux/slub_def.h:13,
>                  from include/linux/slab.h:116,
>                  from include/linux/percpu.h:5,
>                  from include/linux/rcupdate.h:41,
>                  from include/linux/key.h:21,
>                  from include/linux/syscalls.h:67,
>                  from init/noinitramfs.c:23:
> include/linux/pid.h:51: error: field 'rcu' has incomplete type
> In file included from include/linux/smp_lock.h:5,
>                  from include/linux/hardirq.h:5,
>                  from include/linux/slub_def.h:13,
>                  from include/linux/slab.h:116,
>                  from include/linux/percpu.h:5,
>                  from include/linux/rcupdate.h:41,
>                  from include/linux/key.h:21,
>                  from include/linux/syscalls.h:67,
>                  from init/noinitramfs.c:23:
> include/linux/sched.h:1187: error: field 'rcu' has incomplete type
> include/linux/sched.h: In function 'next_thread':
> include/linux/sched.h:1650: error: implicit declaration of function
> 'rcu_dereference'
> include/linux/sched.h:1650: warning: initialization makes pointer from
> integer without a cast
> make[1]: *** [init/noinitramfs.o] Error 1
> make: *** [init] Error 2
>
>
> --
> Jesper Juhl <jesper.juhl@gmail.com>
> Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please      http://www.expita.com/nomime.html
>


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
