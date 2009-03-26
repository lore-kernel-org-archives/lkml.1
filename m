Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbZCZMWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbZCZMWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752764AbZCZMWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:22:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:55629 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZCZMWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:22:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=kxvI/JhxPU0jBiM7EN+gu59nSUN3xS/59gckdHof/kRqeZ8jfJPYfSswsFQZZV5tsR
         Djob1jc1ktmtKJMGcsZM9HUQ5+8dtKW7sqrGhc+cEiDjU3BkJvnr+VcLEhTxLURF7EIN
         amr5TTEJKIMYdG1twdSorhKTgM8gx8tc/XN3k=
MIME-Version: 1.0
In-Reply-To: <20090326090630.GA9369@elte.hu>
References: <20090324103111.GA26691@elte.hu>
	 <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu>
	 <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	 <20090325185824.GO32307@mit.edu>
	 <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	 <20090325215137.GQ32307@mit.edu>
	 <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	 <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
Date: Thu, 26 Mar 2009 14:22:27 +0200
X-Google-Sender-Auth: df0818fb79901be1
Message-ID: <84144f020903260522r78240128j3c7d4691b76b7257@mail.gmail.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Thu, Mar 26, 2009 at 11:06 AM, Ingo Molnar <mingo@elte.hu> wrote:
> Btw., i had this test going on that box while i wrote some simple
> scripts in Vim - and it was a horrible experience. The worst wait
> was well above one minute - Vim just hung there indefinitely. Not
> even Ctrl-Z was possible. I captured one such wait, it was hanging
> right here:

Just a data point: I've seen this exact same time for a long time (1-2
years) too even with stock distribution kernels. Never bothered to
investigate it though.

                        Pekka
