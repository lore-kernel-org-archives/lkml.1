Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbXBJB5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbXBJB5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXBJB5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:57:16 -0500
Received: from raven.upol.cz ([158.194.120.4]:56683 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbXBJB5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:57:15 -0500
Newsgroups: gmane.linux.kernel
Subject: Re: -mm merge plans for 2.6.21
In-Reply-To: <20070209220327.GB16158@flint.arm.linux.org.uk>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <1171042535.29713.96.camel@pmac.infradead.org> <20070209134516.2367a7aa.akpm@linux-foundation.org> <20070209214944.GA16158@flint.arm.linux.org.uk> <1171057999.29713.129.camel@pmac.infradead.org> <20070209220327.GB16158@flint.arm.linux.org.uk>
Organization: Palacky University in Olomouc, experimental physics department.
To: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org, drepper@redhat.com, olecom@flower.upol.cz
Date: Sat, 10 Feb 2007 03:05:58 +0100
Message-Id: <E1HFhck-0008J9-KG@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Russell King
> Newsgroups: gmane.linux.kernel
> Subject: Re: -mm merge plans for 2.6.21
> Date: Fri, 9 Feb 2007 22:03:27 +0000
[]
> However:
>
> sys_foo(int a, int c, unsigned long long b, unsigned long long d)
>
> is entirely reasonable and leaves us with spare room for one additional
> 32-bit arg to be passed.
>
>> Is that actually written anywhere, and does anyone bother to check?
>
> Mostly mailing list archives I'd guess.  As far as anyone bothering
> to check, that's me when I'm aware of new syscalls... which typically
> happens a long time after the syscalls have been introduced on x86
> etc.

Why not to have "the most large argument first" rule here?

  sys_bar(largest,..., larger,..., smaller,..., small);

Put it in Documentation/ABI/README and bother only, when compiller
will bark on -mm tree.

____
