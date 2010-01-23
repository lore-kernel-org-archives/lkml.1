Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982Ab0AWIFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0AWIFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 03:05:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825Ab0AWIFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 03:05:11 -0500
Received: from mail-iw0-f186.google.com ([209.85.223.186]:56472 "EHLO
	mail-iw0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab0AWIFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 03:05:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OKzfF3q0VRuLsjcz/29zezC8pqGVWuwkFGsfnvlQDgJoTV6ApZdIYWgFYNAJFo/W7O
         QrZSsRv8GP6O98A2tA7ETrdg60vmGuxRU3idYGenBCqMebCafHhrjRaSAdd7knfw7NPo
         PPsbB1ou6LcBcAlZLce3Zwf24eaXjnlqhaNuM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	 <20100122005147.GD22003@redhat.com>
	 <20100121170541.7425ff10.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	 <20100122182827.GA13185@redhat.com>
	 <20100122200129.GG22003@redhat.com>
	 <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	 <20100122221348.GA4263@redhat.com>
	 <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	 <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
Date: Sat, 23 Jan 2010 10:05:07 +0200
Message-ID: <b6fcc0a1001230005n5eaf1738lb8413f7c6501ee72@mail.gmail.com>
Subject: Re: linux-next: add utrace tree
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 2:22 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> This is why when somebody brought up "you could do a seccomp-like thing on
> top of utrace" that my reaction was and is just totally negative. It shows
> all the wrong kinds of tying things together.

seccomp-via-utrace should be just removed to be honest before its users.
It entered the tree because it was very small and simple.
If rewritten, it no longer is small and simple because of whole kernel/utrace.c.
