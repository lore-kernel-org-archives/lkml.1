Return-Path: <linux-kernel-owner+w=401wt.eu-S1759242AbZF3BxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbZF3BxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZF3BxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:53:04 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40343 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZF3BxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:53:03 -0400
Date: Mon, 29 Jun 2009 19:53:03 -0600
From: dann frazier <dannf@dannf.org>
To: Stephen Frost <sfrost@snowman.net>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Subject: Re: ACPI issues on HP DL585 G2
Message-ID: <20090630015302.GN22480@ldl.fc.hp.com>
References: <20090628034038.GK20436@tamriel.snowman.net>
 <20090628172052.GA13957@ldl.fc.hp.com>
 <20090628223258.GP20436@tamriel.snowman.net>
 <20090630011541.GL22480@ldl.fc.hp.com>
 <20090630011709.GT20436@tamriel.snowman.net>
 <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com>
 <20090630015140.GV20436@tamriel.snowman.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630015140.GV20436@tamriel.snowman.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 09:51:40PM -0400, Stephen Frost wrote:
> * Yinghai Lu (yhlu.kernel@gmail.com) wrote:
> > it seems storage cards are different.
> > 
> > dann's is 42:01.0 the LSI
> > your's is 42.02.0 the cciss?
> 
> Yeah, I have a P600 installed in this DL585.
> 
> lspci -v for the P600:
> 
> 42:02.0 RAID bus controller: Hewlett-Packard Company Smart Array P600
>         Subsystem: Hewlett-Packard Company 3 Gb/s SAS RAID
>         Flags: bus master, 66MHz, medium devsel, latency 120, IRQ 11
>         Memory at dfef0000 (64-bit, non-prefetchable) [size=8K]
>         I/O ports at 3000 [size=256]
>         Memory at dfe80000 (64-bit, non-prefetchable) [size=256K]
>         [virtual] Expansion ROM at de000000 [disabled] [size=256K]
>         Capabilities: <access denied>
>         Kernel driver in use: cciss
> 
> Of course, it seems to work ok under 2.6.22..

What about your other working DL585 boxes? Are they G2's, and are they
also using P600s?

-- 
dann frazier

