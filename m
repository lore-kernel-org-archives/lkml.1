Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZAELY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZAELY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZAELYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:24:18 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43214 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751680AbZAELYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:24:17 -0500
Date: Mon, 5 Jan 2009 11:23:50 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: atomics: document that linux expects certain atomic behaviour
 from unsigned long
Message-ID: <20090105112350.3e665114@lxorguk.ukuu.org.uk>
In-Reply-To: <200901052154.45958.nickpiggin@yahoo.com.au>
References: <20090103124400.GA1572@ucw.cz>
	<20090103205628.GE1666@elf.ucw.cz>
	<20090103231419.197727ba@lxorguk.ukuu.org.uk>
	<200901052154.45958.nickpiggin@yahoo.com.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pretty much everywhere that uses RCU for example does so using atomic pointer
> loads and stores. The nastiest issue IMO actually is reloading the value
> through the pointer even if it isn't explicitly dereferenced. RCU gets this
> right with ACCESS_ONCE. Probably a lot of code using basic types does not.
> x86 atomic_read maybe should be using ACCESS_ONCE too...

I'm pretty sure it should. gcc makes no guarantees about not being clever
with accesses.

Alan
