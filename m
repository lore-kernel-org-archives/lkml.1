Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYLZXMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYLZXMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 18:12:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbYLZXMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 18:12:41 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56458 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbYLZXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 18:12:41 -0500
Date: Sat, 27 Dec 2008 00:12:36 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Steve Brokenshire <sbrokenshire@xestia.co.uk>,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Compress kernel modules on installation.
In-Reply-To: <20081226225748.GA25143@uranus.ravnborg.org>
Message-ID: <alpine.LSU.2.00.0812270005200.12031@fbirervta.pbzchgretzou.qr>
References: <20080225214209.a3f79327.sbrokenshire@xestia.co.uk> <20080226112840.GA29465@uranus.ravnborg.org> <alpine.LSU.2.00.0812262026320.11203@fbirervta.pbzchgretzou.qr> <20081226194833.GA8306@uranus.ravnborg.org> <alpine.LSU.2.00.0812262049040.12031@fbirervta.pbzchgretzou.qr>
 <20081226225748.GA25143@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2008-12-26 23:57, Sam Ravnborg wrote:
>>>
>>>Steve said [in Feb 2008] he wanted to try to make the solution
>>>more scalable so I am awaiting a new patch.
>> 
>>Hm, all I needed was this patch. It might fire up some people,
>>but it's got all the scalability I could think of..
>
>Jan - there is obviously no way I could apply this patch
>so late in the cycle. 

2.6.29 just started, did not it. Even if not, just queue it for
the next.

>The original patch that made this a CONFIG option is
>then much better as we avoid forcing new and untested
>behaviour on the users.
>
>We all know that compressing the modules are simple.
>And unless someone comes up with *very* good arguments
>then we should just use gzip with default parameters.

Besides the -9 flag, where would there be nondefault
parameters?

>If we go for the "keep the .ko extension but compress"
>then someone needs to answer the obvious questions:
>
>- will this break on a typical distribution

No; module-init-tools already uses gzopen even on
uncompressed files.

>- will this break busybox users

I did not see any gzip support in there, so the
answer is likely "yes, as usual".
