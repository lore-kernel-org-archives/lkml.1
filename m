Return-Path: <linux-kernel-owner+w=401wt.eu-S1764821AbXKUAWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764821AbXKUAWv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757866AbXKUAWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:22:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36567 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757601AbXKUAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:22:43 -0500
Date: Wed, 21 Nov 2007 00:20:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Time-based RFC 4122 UUID generator
Message-ID: <20071121002046.2f95aac9@the-village.bc.nu>
In-Reply-To: <fhvoqu$u6l$1@ger.gmane.org>
References: <fhqbkn$ttt$1@ger.gmane.org>
	<MDEHLPKNGKAHNMBLJOLKCECCIFAC.davids@webmaster.com>
	<fhvoqu$u6l$1@ger.gmane.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2007 23:58:38 +0100
Helge Deller <deller@gmx.de> wrote:

> David Schwartz wrote:
> > Any UUID generator that can produce duplicate UUIDs with probability
> > significantly less than purely random UUIDs is so badly broken that it
> > should not ever be used. Anyone who finds such a UUID generator should
> > immediately either fix it or throw it on the junk heap. 
> 
> That's what my patch is about: Solve the problem at it's root.

Time based is not neccessarily random, but the kernel one is also clearly
not random either.

Alan
