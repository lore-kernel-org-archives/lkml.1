Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYJUJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYJUJjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYJUJjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 05:39:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36831 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbYJUJjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 05:39:06 -0400
Date: Tue, 21 Oct 2008 10:38:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Tomaso.Paoletti@caviumnetworks.com
Subject: Re: [PATCH] serial: Initialize spinlocks in 8250 and don't clobber
 them.
Message-ID: <20081021103833.5e960c8d@lxorguk.ukuu.org.uk>
In-Reply-To: <20081020141750.d0610586.akpm@linux-foundation.org>
References: <48F51114.2010105@caviumnetworks.com>
	<20081020141750.d0610586.akpm@linux-foundation.org>
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

> But yes, copying a spinlock by value is quite wrong.  Perhaps we could
> retain the struct assigment and then run spin_lock_init() to get the
> spinlock into a sane state?

Kind of irrelevant now however, the split of patches that caused the
original bug is over and the NR_IRQ removal patch half of it hit Linus
tree.

Alan
