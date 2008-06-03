Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYFCPGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYFCPGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYFCPGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:06:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39044 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753986AbYFCPGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:06:08 -0400
Date: Tue, 3 Jun 2008 15:46:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Cammarata <jimi@sngx.net>
Cc: Bill Fink <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-ID: <20080603154602.01b10adb@core>
In-Reply-To: <48453909.4000301@sngx.net>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
	<20080530151250.b44a119a.billfink@mindspring.com>
	<20080531131143.516ca56e@core>
	<20080531195702.0b879dd1.billfink@mindspring.com>
	<48437C25.7080400@gdt.id.au>
	<20080602121007.1e81cf05.billfink@mindspring.com>
	<48453909.4000301@sngx.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Also, I'd like to point out that the "stepping on other peoples toes" 
> argument is a bogus one, since most major network vendors include this 
> ability, and it's not exactly a concern now.

I used to work in a large ISP - it was a huge concern then and was
enforced and managed by the less effective 'do you like your kneecaps'
approach to permissions.

Its basically impossible to write a correct non-racy application which
zeros kernel statistics and then measures the change, because you cannot
know another application did the same while you were running.

This is the most basic and blindingly obvious stuff. You should not be
able to zero the kernel stats just because you can't work perl.

Alan
