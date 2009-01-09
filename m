Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZAIVWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZAIVWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbZAIVV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:21:56 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47246 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753028AbZAIVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:21:55 -0500
Date: Fri, 9 Jan 2009 21:22:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Partially defer some of the async stuff to the next release
Message-ID: <20090109212201.780c52d0@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0901091241470.6528@localhost.localdomain>
References: <20090109070910.233e5f3c@infradead.org>
	<alpine.LFD.2.00.0901091241470.6528@localhost.localdomain>
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

> Can we rather make this something that people can enable with a "fastboot" 
> option and is disabled by default? At least that way the ATA people can 
> see the problem, and don't just forget about it, since we want it fixed.

Makes some sense - although the inode one should just take a hike at this
point. Can the fastboot option live under staging perhaps - its analogous
to staging drivers although clearly the code doesn't go there in this
case ?

The trouble otherwise is "fast boot" sounds like something good for
people to turn on, but right now it's the reverse.

Alan
