Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbXFTQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbXFTQwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 12:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbXFTQw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 12:52:28 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50910 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754203AbXFTQw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 12:52:26 -0400
Date: Wed, 20 Jun 2007 17:56:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew McKay <amckay@iders.ca>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Ingo Molnar <mingo@elte.hu>, Daniel Hazelton <dhazelton@enter.net>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070620175627.319a6c55@the-village.bc.nu>
In-Reply-To: <4679557C.5080907@iders.ca>
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614195517.GA4933@elte.hu>
	<orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614235004.GA14952@elte.hu>
	<20070615011012.6c09066e@the-village.bc.nu>
	<20070615012623.GA25189@elte.hu>
	<20070615101007.0cbfd078@the-village.bc.nu>
	<orir9p10xw.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4673CA7C.5040207@t-online.de>
	<orlkejrg4o.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070616181902.GB21478@ftp.linux.org.uk>
	<or1wgbras9.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706161952280.14121@woody.linux-foundation.org>
	<orabuzkw0i.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<4679557C.5080907@iders.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Secondly GPLv3 will cause companies like TIVO, router companies, security 
> companies to not adopt Linux as an operating system, because they can't secure 
> their system.  Placing code in a ROM so they can't upgrade their own systems is 

You've made an important mistake. You said "their system". Now its "our
code" and "whoever bought the units' hardware" so it isn't their anything.

You've made a second mistake I think by assuming that vendor held keys
"improve" security and must be vendor held and secret for it to work. In
fact vendor owned key systems that cannot be changed usually reduce
security.

There are very very good reasons for having vendor owned secret keys.
There are also very very good reasons for being able to rekey or disable
the key on your box.

Ask people whose product vendor went bankrupt. With the ability to
override/replace the keys they could have maintained their system
securely instead they could make no updates and the boxes were left
insecure.

RPM for example intentionally follows this approach. RPM will check keys
and the keys for different vendors/projects will not be released. However
you can add keys, remove keys or even tell rpm "forget the key checking".

A silly example that rather makes the point is the X-Box. Using a bug in
a game you can get into the X-box system and run Linux instead. As the
owner of an X-box you can't fix the bug in the game because you don't
know the signing key, but if you could change or add keys you could stop
the "problem" occurring.

The Xbox is perhaps an oddity in that the insecurity is widely preferred
by the owners but the situation applies in cases where the owner would
prefer the reverse were true.

