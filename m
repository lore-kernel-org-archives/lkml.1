Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbXLCWBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbXLCWBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 17:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXLCWBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 17:01:42 -0500
Received: from [81.2.110.250] ([81.2.110.250]:36579 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750764AbXLCWBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 17:01:41 -0500
Date: Mon, 3 Dec 2007 21:57:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071203215727.543fc757@the-village.bc.nu>
In-Reply-To: <20071203223902.1194aa69@werewolf>
References: <474EAD18.6040408@stellatravel.co.uk>
	<20071130143445.GA2310@csclub.uwaterloo.ca>
	<53ADBDBF-9B65-441E-B867-D68DE48ABD64@mac.com>
	<4751BE0D.3050609@argo.co.il>
	<p733aukyl8n.fsf@bingen.suse.de>
	<47539030.10600@argo.co.il>
	<20071203095022.GA28560@one.firstfloor.org>
	<4753ECA5.2010604@argo.co.il>
	<20071203211353.GA4009@1wt.eu>
	<20071203223902.1194aa69@werewolf>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You could write an equally effcient kernel in languages like C++,
> using C++ abstractions as a high level organization, where

It's very very hard to generate good C code because of the numerous ways
objects get temporarily created, and the week aliasing rules (as with C).

There are reasons that Fortran lives on (and no I'm not suggesting one
should rewrite the kernel in Fortran ;)) and the fact its not really got
pointer aliasing or "address of" operators and all the resulting
optimsation problems is one of the big ones.

Alan
