Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbZJGS5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbZJGS5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZJGS5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:57:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbZJGS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:57:29 -0400
Subject: Re: system gets stuck in a lock during boot
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4ACCE1BA.5000307@gmail.com>
References: <1251096925.7538.121.camel@twins> <4A9251EB.8040805@gmail.com>
	 <dd18b0c30908241219mdb76311t9334929f34f2c4c3@mail.gmail.com>
	 <20090825085919.GB14003@elte.hu> <4A94803A.5060408@gmail.com>
	 <20090826073351.GE23435@elte.hu> <4A9549E5.5020002@gmail.com>
	 <dd18b0c30909071449q6834e847yb0f27ec971c9564a@mail.gmail.com>
	 <20091002211211.GA2633@redhat.com>
	 <1254792249.13160.213.camel@gandalf.stny.rr.com>
	 <20091006203225.GC2631@redhat.com>
	 <1254880921.1696.112.camel@gandalf.stny.rr.com>
	 <4ACC001D.4050105@gmail.com>
	 <1254920429.1696.127.camel@gandalf.stny.rr.com>
	 <4ACCAB54.4010408@gmail.com>
	 <1254928298.1696.166.camel@gandalf.stny.rr.com>
	 <4ACCB934.7070805@gmail.com>
	 <1254931582.1696.171.camel@gandalf.stny.rr.com>
	 <4ACCE1BA.5000307@gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 07 Oct 2009 14:55:30 -0400
Message-Id: <1254941730.1696.177.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 11:45 -0700, Justin P. Mattock wrote:

> >    
> yep like I said I owe you guys an apology, for
> my mistake(thanks for taking the time).

Well, thank you for reporting it. If nobody reports any problems, we
just assume everything is OK, and as people curse us out and look for
alternatives, we will be sipping our mai-tais in ignorant bliss.

-- Steve

> 
>  From what it looks like init was looking for libselinux
> in /lib instead of /lib64.
> after adjusting the Makefile and adding:
> LDFLAGS = -s -L/lib64 -lselinux -lsepol
> LIBDIR=/lib64
> the system boots right up.
> (sh*t built everything to point to lib64(xserver and all).., and
> forgot the modify init.c to do the same).
> 
> Justin P. Mattock
> 

