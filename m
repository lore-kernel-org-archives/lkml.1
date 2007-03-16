Return-Path: <linux-kernel-owner+w=401wt.eu-S965587AbXCPQpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587AbXCPQpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 12:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXCPQpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 12:45:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50954 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582AbXCPQpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 12:45:04 -0400
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Bodo Eggert" <7eggert@gmx.de>,
       "Eric Dumazet" <dada1@cosmosbay.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: sys_write() racy for multi-threaded append?
References: <7WzUo-1zl-21@gated-at.bofh.it> <7WB07-3g5-33@gated-at.bofh.it>
	<7WBt7-3SZ-23@gated-at.bofh.it> <E1HQfLX-0000fk-68@be1.lrz>
	<f2b55d220703120926k1ab7112fh60227fac670b8b4c@mail.gmail.com>
	<Pine.LNX.4.58.0703121803450.2313@be1.lrz>
	<f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	<20070313022430.57503b08@lxorguk.ukuu.org.uk>
	<f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	<20070313131533.1ec468c3@lxorguk.ukuu.org.uk>
	<f2b55d220703141309l20f907c4t6d0bb7dcef724947@mail.gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 16 Mar 2007 12:43:47 -0400
In-Reply-To: <f2b55d220703141309l20f907c4t6d0bb7dcef724947@mail.gmail.com>
Message-ID: <y0mhcsldtq4.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael K. Edwards" <medwards.linux@gmail.com> writes:

> Thanks Alan, this is really helpful -- I'll see if I can figure out
> kprobes.  It is not immediately obvious to me how to use them to
> trace function calls in userspace, but I'll read up.

kprobes does not work with userspace.  We in systemtap land have been
pushing for such an extension, and primarily IBM folks have been
writing one that would be acceptable for LKML.

> [...]  There doesn't seem to be an arch/arm/kernel/kprobes.c, and
> I'm not sure I have the skill to write one.  On the other hand,
> ltrace manages something similar (through libelf), and I can trace
> ltrace's ptrace activity with strace, so maybe I can clone that.
> :-)

Efforts are underway to port kprobes to ARM.

Both these efforts may be tracked on the public systemtap mailing list.

- FChE
