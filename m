Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbYGSKWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbYGSKWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 06:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYGSKVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 06:21:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833AbYGSKVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 06:21:53 -0400
Date: Sat, 19 Jul 2008 06:11:40 -0400
From: Alan Cox <alan@redhat.com>
To: "Rodrigo Rubira Branco (BSDaemon)" <rbranco@LA.CHECKPOINT.COM>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       greg@kroah.com, "'Justin Forbes'" <jmforbes@linuxtx.org>,
       "'Zwane Mwaikambo'" <zwane@arm.linux.org.uk>,
       "'Theodore Ts'o'" <tytso@mit.edu>,
       "'Randy Dunlap'" <rdunlap@xenotime.net>,
       "'Dave Jones'" <davej@redhat.com>,
       "'Chuck Wolber'" <chuckw@quantumlinux.com>,
       "'Chris Wedgwood'" <reviews@ml.cw.f00f.org>,
       "'Michael Krufky'" <mkrufky@linuxtv.org>,
       "'Chuck Ebbert'" <cebbert@redhat.com>,
       "'Domenico Andreoli'" <cavokz@gmail.com>, "'Willy Tarreau'" <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "'Alan Cox'" <alan@redhat.com>,
       caglar@pardus.org.tr, casey@schaufler-ca.com, spender@grsecurity.net,
       pageexec@freemail.hu, rodrigo@kernelhacking.com
Subject: Re: [stable] Linux 2.6.25.10 (resume)
Message-ID: <20080719101140.GB20802@devserv.devel.redhat.com>
References: <20080701151057.930340322@mini.kroah.org> <200807021257.47593.caglar@pardus.org.tr> <20080702144149.GA16850@suse.de> <200807021809.07679.caglar@pardus.org.tr> <005001c8e6f8$ac0955f0$a6181fac@ad.checkpoint.com> <20080716044905.GA9033@suse.de> <4880A3B1.3050103@la.checkpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4880A3B1.3050103@la.checkpoint.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1,7 +1,7 @@
> -Linux kernel developers take security very seriously.  As such, we'd
> -like to know when a security bug is found so that it can be fixed and
> -disclosed as quickly as possible.  Please report security bugs to the
> -Linux kernel security team.
> +Linux kernel developers take security very seriously, in exactly the 
> +same way we do with any other bugs.  As such, we'd like to know when 
> +a security bug is found so that it can be fixed as soon as possible.
> +Please report security bugs to the Linux kernel security team.

NAK this. If the fix is not clear and the bug not too serious it is better
to disclose it than fail to fix it. The security team does not usually fix the
bugs, the experts in the various bits of code do.

> -Any exploit code is very helpful and will not be released without
> -consent from the reporter unless it has already been made public.
> +Any exploit code is very helpful and will not be released.

NAK this too. If someone releases an exploit publically or it leaks we
want to be able to freely share it too. Your proposal would mean any but
those dumb enough to agree to this could share it. That is why the unless made
public is part of every generic NDA document on the planet.


The rest needs Linus to return from holiday for discussion and that'll
be a week or two. In the meantime you might want to define "disclose" as
I don't think we all agree on what it means as you've not defined who is and
isn't the linux security team and/or its helpers.

