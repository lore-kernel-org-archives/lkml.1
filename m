Return-Path: <linux-kernel-owner+w=401wt.eu-S1753528AbYI0Q02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbYI0Q02 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 12:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYI0Q0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 12:26:20 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41584 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595AbYI0Q0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 12:26:20 -0400
Date: Sat, 27 Sep 2008 17:25:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, jbarnes@virtuousgeek.org,
       mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] ioremap sanity check to catch mapping requests
 exceeding the BAR sizes
Message-ID: <20080927172546.6220ccbb@lxorguk.ukuu.org.uk>
In-Reply-To: <48DE46AB.8070505@goop.org>
References: <20080926014334.GF15609@linux-os.sc.intel.com>
	<48DDDDDE.7060707@goop.org>
	<20080927122145.49ad0cf4@lxorguk.ukuu.org.uk>
	<48DE46AB.8070505@goop.org>
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

On Sat, 27 Sep 2008 07:43:55 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Alan Cox wrote:
> >> Any attempt to use ioremap on memory is a bug, so you should warn about
> >> that too.
> >>     
> >
> > We use it to ioremap things like the BIOS...
> 
> Yeah, that's fine.  I mean using ioremap on system memory is a bug.

On system memory mapped by the kernel which I assume is what you mean -
the BIOS is often shadowed system memory and we have platforms where
memory pages not mapped into or managed the OS are ioremap() targets.

That however is getting pedantic - I just didn't want anyone to overdo
the sanity checks

Alan
