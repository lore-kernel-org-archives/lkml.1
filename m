Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbXLDUqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbXLDUqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 15:46:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXLDUqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 15:46:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42734 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbXLDUqL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 15:46:11 -0500
Date: Tue, 4 Dec 2007 20:40:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Matt Mackall <mpm@selenic.com>, Ray Lee <ray@madrabbit.org>,
       Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       mmcgrath@redhat.com
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071204204036.484f11ac@the-village.bc.nu>
In-Reply-To: <20071204195021.GB7259@thunk.org>
References: <20071204114125.GA17310@torres.zugschlus.de>
	<20071204161811.GB15974@stusta.de>
	<2c0942db0712040854u17a830b9see663742b2716457@mail.gmail.com>
	<20071204165502.0a8f695e@the-village.bc.nu>
	<20071204180237.GU19691@waste.org>
	<20071204195021.GB7259@thunk.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, are you sure you're not talking about Helge Deller's attempt to
> push a Time-based UUID generator into the kernel because you can get
> duplicates from the current userspace library?

Yes

> I've not heard of *any* claim where the kernel uuid random generator
> has been returning duplicates.

Then the original reports got lost somewhere.

The Fedora tools use a kernel random uuid for system identifiers (to
preserve anonymity while allowing system profiles etc to be generated and
to know which are duplicates).

We seen a huge number of duplicates for certain values:

>From Mike McGrath (added to Cc)

> Here's the top 5:
>
>    266 28caf2c3-9766-4fe1-9e4c-d6b0ba8a0132
>    336 810e7126-1c69-4aff-b8b1-9db0fa8aa15a
>    402 c8dbb9d3-a9bd-4ba6-b92e-4a294ba5a95f
>    884 06e84493-e024-44b1-9b32-32d78af04039
>    931 e2b67e1d-e325-4740-b938-795addb45280
>
> The left number is times this month someone has submitted a profile with
> that UUID.  If we take the last one as an example has come from over 800
> IP's in the last 20 days.  It seems very unlikely that one person would
> find his way to 800 different IP's this month.  Let me know if you'd
> like more.
