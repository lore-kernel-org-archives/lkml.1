Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZKXHPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZKXHPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZKXHPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:15:07 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:47381 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZKXHPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:15:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=JjktOVuFlir21W2PMwmoFhF77aViAnslxALAPNauXz7e53DkdIH2KUVaf384W9Hc4c
         5Vv7CNAyigjI4Y6MM9WRpl4kHCiSDOa5S3jpPXdNzfp87W5BmBBIVdva8l+aQyNYTQEi
         4JLLD4rDVlPH6Ed/5YQy/5tMx599kFsFVPIcA=
MIME-Version: 1.0
In-Reply-To: <4B0B6E44.6090106@cn.fujitsu.com>
References: <4B0B6E44.6090106@cn.fujitsu.com>
Date: Tue, 24 Nov 2009 09:15:10 +0200
X-Google-Sender-Auth: cd19c3d7f7ca7b83
Message-ID: <84144f020911232315h7c8b7348u9ad97f585f54a014@mail.gmail.com>
Subject: Re: [PATCH 0/5] perf kmem: Add more functions and show more 
	statistics
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On Tue, Nov 24, 2009 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Pekka, do you think we can remove kmemtrace now?

One more use case I forgot to mention: boot time tracing. Much of the
persistent kernel memory footprint comes from the boot process which
is why it's important to be able to trace memory allocations
immediately after kmem_cache_init() has run. Can we make "perf kmem"
do that? Eduard put most of his efforts into making that work for
kmemtrace.

On Tue, Nov 24, 2009 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> With kmem trace events, low-level analyzing can be done using
> ftrace, and high-level analyzing can be done using perf-kmem.
>
> And chance is, more people may use and improve perf-kmem, and it
> will be well-maintained within the perf infrastructure. On the
> other hand, I guess few people use and contribute to kmemtrace-user.

Sure, I think "perf kmem" is the way forward. I'd love to hear
Eduard's comments on this before we remove the code from kernel. Do we
need to do that for 2.6.33 or can we postpone that for 2.6.34?

                        Pekka
