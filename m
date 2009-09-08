Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZIHXVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZIHXVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 19:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbZIHXVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 19:21:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:55988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZIHXVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 19:21:00 -0400
Date: Wed, 9 Sep 2009 01:20:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Nikos Chantziaras <realnc@arcor.de>
Cc: Juergen Beisert <jbe@pengutronix.de>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
In-Reply-To: <4AA6D40F.6040600@arcor.de>
Message-ID: <alpine.LRH.2.00.0909090120531.25928@twin.jikos.cz>
References: <20090906205952.GA6516@elte.hu> <20090908013800.296a5fb5@infradead.org> <4AA62E4E.4040700@arcor.de> <200909081332.46129.jbe@pengutronix.de> <4AA6D40F.6040600@arcor.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009, Nikos Chantziaras wrote:

> > > Here the result:
> > > 
> > >       http://foss.math.aegean.gr/~realnc/pics/latop2.png
> > > 
> > > Again: this is on an Intel Core 2 Duo CPU.
> > 
> > Just an idea: Maybe some system management code hits you?
> 
> I'm not sure what is meant with "system management code."

System management interrupt happens when firmware/BIOS/HW-debugger is 
executed in privilege mode so high, that even OS can't do anything about 
that.

It is used in many situations, such as

- memory errors
- ACPI (mostly fan control)
- TPM

OS has small to none possibility to influence SMI/SMM. But if this would 
be the cause, you should probably obtain completely different results on 
different hardware configuration (as it is likely to have completely 
different SMM behavior).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
