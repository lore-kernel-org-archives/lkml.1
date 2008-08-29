Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbYH2Jre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbYH2Jre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYH2Jr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:47:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56537 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751417AbYH2JrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:47:25 -0400
Date: Fri, 29 Aug 2008 10:25:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Hugh Dickens <hugh@veritas.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
Message-ID: <20080829102547.655440bf@lxorguk.ukuu.org.uk>
In-Reply-To: <48B76CE0.5010309@goop.org>
References: <48B701FB.2020905@goop.org>
	<86802c440808281849nb972d64te89894077ea9f33c@mail.gmail.com>
	<48B76CE0.5010309@goop.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>  - Clears the reserved memory so we can observe changes to it.

You ought to pick different values on different runs 0x00, 0xFF, 0xAA,
0x55 etc...

> Yeah, OK, but I think it should default to ON for now.  The problem is
> that we had two very different systems (Sony Vaio and Intel desktop)

So a zillion people should lose a chunk of RAM because of what is
probably an obscure bug in a single version of a piece of SMM code on two
systems total ?

That appears to be totally out of proportion - plus the defaults are
*irrelevant* for mass user coverage. If you want large scale coverage ask
the Fedora, OpenSuSE and Ubuntu people to turn it on for a testing kernel
release and report back.

Alan
