Return-Path: <linux-kernel-owner+w=401wt.eu-S935173AbYBNAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935173AbYBNAav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934152AbYBNA0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:26:33 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60762 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934822AbYBNA0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:26:31 -0500
Date: Thu, 14 Feb 2008 00:18:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, harvey.harrison@gmail.com,
       torvalds@linux-foundation.org, davem@davemloft.net, tglx@linutronix.de,
       hpa@zytor.com, xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] feature-removal: add documentation for exported
 symbols going away
Message-ID: <20080214001836.687f03f7@core>
In-Reply-To: <20080213235843.GG12383@cs181133002.pp.htv.fi>
References: <1202941327.18204.11.camel@brick>
	<20080213223455.GB12383@cs181133002.pp.htv.fi>
	<20080213224308.GD12383@cs181133002.pp.htv.fi>
	<20080213145405.35fb5733.akpm@linux-foundation.org>
	<20080213232248.GF12383@cs181133002.pp.htv.fi>
	<20080213154331.f11efc63.akpm@linux-foundation.org>
	<20080213235843.GG12383@cs181133002.pp.htv.fi>
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

> Unexports are done immediately when there's a subsystem maintainer 
> taking a patch and deprecation periods are required when a patch has to 
> go through you...

Agreed - with the expect of stuff which is used in tree or forms part of
a logical exported API we should just throw them out without messing. The
only exceptions I can see that make sense are

- Where a subsystem maintainer says not to
- Where we know that a commonly used out of tree module needs it

Most of the excess symbols should thus just go away. Its pretty unlikely
that they are being used.

Alan
