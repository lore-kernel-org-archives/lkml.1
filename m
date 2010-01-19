Return-Path: <linux-kernel-owner+w=401wt.eu-S1755177Ab0ASHhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab0ASHhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:37:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058Ab0ASHhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:37:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34350 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab0ASHhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=r1/iGmnYJHvhb4TTmOLsrpuXGiz2jVuYKwyGzWYopchw7Q6ErOW30BlYzTApDEi0o+
         nXrNt4JiH/cXObdzmnXkQ6Nd4ZiceAPN/mVxNjgsWcmk7Q69JZzGR1miCffjdgFnK3Ko
         aolJEyvF+wV//orIigo7wkSxpL/6kxL+yozy8=
MIME-Version: 1.0
In-Reply-To: <20100119071734.GG14345@redhat.com>
References: <20100118133755.GG30698@redhat.com>
	 <84144f021001180609r4d7fbbd0p972d5bc0e227d09a@mail.gmail.com>
	 <20100118141938.GI30698@redhat.com>
	 <84144f021001180805q4d1203b8qab8ccb1de87b2866@mail.gmail.com>
	 <20100118170816.GA22111@redhat.com>
	 <84144f021001181009m52f7eaebp2bd746f92de08da9@mail.gmail.com>
	 <20100118181942.GD22111@redhat.com>
	 <20100118191031.0088f49a@lxorguk.ukuu.org.uk>
	 <20100119071734.GG14345@redhat.com>
Date: Tue, 19 Jan 2010 09:37:05 +0200
X-Google-Sender-Auth: e21225a28b9c7ee4
Message-ID: <84144f021001182337o274c8ed3q8ce60581094bc2b9@mail.gmail.com>
Subject: Re: [PATCH v6] add MAP_UNLOCKED mmap flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Gleb Natapov <gleb@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org,
       andrew.c.morrow@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On Tue, Jan 19, 2010 at 9:17 AM, Gleb Natapov <gleb@redhat.com> wrote:
> The thread took a direction of bashing mlockall(). This is especially
> strange since proposed patch actually makes mlockall() more fine
> grained and thus more useful.

No, the thread took a direction of you not being able to properly
explain why we want MMAP_UNLOCKED in the kernel. It seems useless for
real-time and I've yet to figure out why you need _mlockall()_ if it's
a performance thing.

It would be probably useful if you could point us to the application
source code that actually wants this feature.

                        Pekka
