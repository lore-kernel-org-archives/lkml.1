Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbYAAOjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbYAAOjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 09:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYAAOjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 09:39:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33821 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038AbYAAOjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 09:39:06 -0500
Date: Tue, 1 Jan 2008 14:30:22 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
Message-ID: <20080101143022.664e8894@the-village.bc.nu>
In-Reply-To: <20080101142623.GA3592@elte.hu>
References: <20080101134809.GK2360@does.not.exist>
	<20080101142623.GA3592@elte.hu>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008 15:26:23 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> > This patch removes the EXPERIMENTAL option and all dependencies on 
> > EXPERIMENTAL since they are pointless.
> 
> agreed. CONFIG_BROKEN has real use - but CONFIG_EXPERIMENTAL is pretty 
> pointless in the 90-days kernel development model.

Then I need a replacement equivalent for the ATA layer and all the other
drivers using it to indicate stuff that *IS* experimental, or not yet
known to be highly robust. Drivers are not the same as core code Ingo and
the world driver writers live in is very different to the one you operate
in as is clearly shown by this and by the _p discussion.

Still NAK.  As the alternative is

CONFIG_ATA_EXPERIMENTAL, CONFIG_NET_EXPERIMENTAL,
CONFIG_VIDEO_EXPERIMENTAL, ... all being added by developers

We will also need experimental badly in future when the EU liability
rules (and probably the US ones in a similar time scale) change so that
liability applies to software, because then it will be very important to
clearly label code that is experimental or development code as such.

Alan
