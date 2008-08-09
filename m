Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbYHIWMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbYHIWMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYHIWMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:12:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51409 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752288AbYHIWMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:12:39 -0400
Date: Sat, 9 Aug 2008 22:55:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       video4linux-list@redhat.com,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] V4L1: make PMS not auto-grab port 0x250
Message-ID: <20080809225502.27b38a9d@lxorguk.ukuu.org.uk>
In-Reply-To: <489E13C0.4010807@keyaccess.nl>
References: <489DE890.1090103@keyaccess.nl>
	<20080809214657.3b5318d1@lxorguk.ukuu.org.uk>
	<489E13C0.4010807@keyaccess.nl>
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

> > Just apply a tiny bit of rational thought here. There is exactly ONE 
> > Ingo.
> 
> And as you say yourself -- close to exactly 1 person who still has this 
> hardware and closer still to 0 who use it. Really, you contradict yourself:

Consider the posibility that I might be talking about the general case
here. And if there are two people with the PMS card thats the general
case 8)

> We know this driver breaks the boot during useful kernel work. We know 
> that changing it has about a 0.0001% percent change of mattering to 
> anyone and then only as long as all those person can't be bothered to 
> setup a value in his modprobe.conf.

It never breaks anything for anyone as a module, only compiled in. Which
despite your moans about 'factual' things is a fact.

Can I suggest a rather more elegant solution would be to add a
"CONFIG_UNSAFE_PROBES" tristate (so you can decide if you want no unsafe
probing devices, unsafe probing devices only as modules, or anything goes)

Alan
