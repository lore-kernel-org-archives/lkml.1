Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYIDJU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYIDJU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 05:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYIDJUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 05:20:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41368 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540AbYIDJUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 05:20:50 -0400
Date: Thu, 4 Sep 2008 10:19:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: linux-next: Tree for September 3
Message-ID: <20080904101936.086513fc@lxorguk.ukuu.org.uk>
In-Reply-To: <20080904001558.875f58b1.akpm@linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<20080903215455.792c78a3.akpm@linux-foundation.org>
	<20080904145744.3f791ca7.sfr@canb.auug.org.au>
	<20080903220546.bd673658.akpm@linux-foundation.org>
	<20080904152015.3145b06e.sfr@canb.auug.org.au>
	<20080903230129.806d54af.akpm@linux-foundation.org>
	<20080904001558.875f58b1.akpm@linux-foundation.org>
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

On Thu, 4 Sep 2008 00:15:58 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 3 Sep 2008 23:01:29 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I'll see if I cen reproduce the bug I'm
> > actually tring to find with E100=n.
> 
> OK, this regression[*] bisects down to


Your first serious looking error:
"Module 'acpi' failed to be added to sysfs, error number -17
 The system will be unstable now."

is not even connected to this area of the code.


and I can't find any meaningful description of your regression to attempt
to duplicate it on a cleaner tree without it already saying "I'm unstable"

