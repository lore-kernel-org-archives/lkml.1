Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbYBEPsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbYBEPsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYBEPr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:47:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51245 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751969AbYBEPr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:47:57 -0500
Date: Tue, 5 Feb 2008 15:42:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glenn Griffin <ggriffin.kernel@gmail.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
Message-ID: <20080205154213.059ac6e8@core>
In-Reply-To: <20080205155558.GA23145@one.firstfloor.org>
References: <47a79d64.16538c0a.5b6a.ffffb0fe@mx.google.com>
	<20080205155558.GA23145@one.firstfloor.org>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Syncookies are discouraged these days. They disable too many 
> valuable TCP features (window scaling, SACK) and even without them 
> the kernel is usually strong enough to defend against syn floods
> and systems have much more memory than they used to be.

Somewhat untrue. Network speeds have risen dramatically, the number of
appliances running Linux that are not PC class means memory has fallen
not risen and CPU has been pretty level.

> So I don't think it makes much sense to add more code to it, sorry.

I think it makes a lot of sense - providing it defaults off for the PC
world where as you say its use is limited.

Alan
