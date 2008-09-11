Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYIKUe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYIKUe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 16:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYIKUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 16:34:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41047 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926AbYIKUeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 16:34:46 -0400
X-Greylist: delayed 2900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Sep 2008 16:34:45 EDT
Date: Thu, 11 Sep 2008 20:14:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Hancock <hancockr@shaw.ca>, mikhail.kshevetskiy@gmail.com,
       linux-kernel@vger.kernel.org, aabdulla@nvidia.com, jgarzik@pobox.com
Subject: Re: forcedeth: option to disable 100Hz timer (try 2)
Message-ID: <20080911201420.2757a723@the-village.bc.nu>
In-Reply-To: <20080910221947.94409642.akpm@linux-foundation.org>
References: <fa.iCGOiwuSYhYKpu85Kihny1t9YbA@ifi.uio.no>
	<fa.4uZtuq0waBlpfBb/4OLq4bM5Pj8@ifi.uio.no>
	<48C863CC.3010902@shaw.ca>
	<20080910173630.d0d38697.akpm@linux-foundation.org>
	<48C89D9F.5080404@shaw.ca>
	<20080910221947.94409642.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But it's quite likely that at least some of the 
> > chipsets that this driver supports don't need this timer nonsense at all
> 
> Well yes.  If all the chipsets need the timer then there's nothing we
> can do to improve it.

Surely you only need the timer running when transmits are active and
sufficient transmits to make it worth recovering the queued memory ?
