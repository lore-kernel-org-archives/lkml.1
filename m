Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXEINsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXEINsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXEINsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:48:10 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:40191 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755821AbXEINsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:48:09 -0400
Date: Wed, 9 May 2007 15:47:56 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Philippe De Muyter <phdm@macqel.be>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: retry [PATCH] partition : add support for sysv68 partitions
In-Reply-To: <20070509082042.GA14682@ingate.macqel.be>
Message-ID: <Pine.LNX.4.58.0705091246240.30977@xplor.biophys.uni-duesseldorf.de>
References: <20070413135501.GA27439@ingate.macqel.be> <Pine.LNX.4.64.0705082217340.12497@anakin>
 <20070509072422.GA13119@ingate.macqel.be> <Pine.LNX.4.64.0705090944250.12497@anakin>
 <20070509082042.GA14682@ingate.macqel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > 	`default y if M68K && SYSV_FS'
> >
> > I prefer `default y if VME'.
> >
>
> Incidentally, what is the problem you have with SYSV68_PARTITION ?
> On my i586 machine, code size is 434 bytes for sysv68.o + 4 bytes more in
> check.c

Traditionally, we have always been very conservative about enabling more
than the absolute minimum in partition format support. Some formats can be
erroneously identified by the check code if you don't get the ordering
right (the case I know about, MSDOS partitions vs. Atari TOS/GEM
partitions, hinges on a particular checksum being calculated in the atari
code). I've moved the msdos checker to the bottom of the list more often
than I can keep track of...

If sysv68 cannot be confused with any other format, no harm done by
enabling it by default. Otherwise, things may get interesting.

	Michael
