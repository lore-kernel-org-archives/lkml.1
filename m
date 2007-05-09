Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbXEIIU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbXEIIU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXEIIUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:20:45 -0400
Received: from mail.macqel.be ([194.78.208.39]:2274 "EHLO mail.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbXEIIUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:20:44 -0400
Date: Wed, 9 May 2007 10:20:42 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: retry [PATCH] partition : add support for sysv68 partitions
Message-ID: <20070509082042.GA14682@ingate.macqel.be>
References: <20070413135501.GA27439@ingate.macqel.be> <Pine.LNX.4.64.0705082217340.12497@anakin> <20070509072422.GA13119@ingate.macqel.be> <Pine.LNX.4.64.0705090944250.12497@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705090944250.12497@anakin>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

> > What do you think of
> > 	`default y if VME'
> > or
> > 	`default y if M68K && SYSV_FS'
> 
> I prefer `default y if VME'.
> 
> BTW, perhaps PPC based Motorola MVME boards use SYSV68 partition tables,
> too?

No, the PPC based Motorola MVME boards use the (currently not supported by
linux) AIX partition tables, as do also the motorola powerstack machines.

The m88k based Motorola MVME boards use the sysV68 partition tables, but
m88k is not yet supported by linux.

Incidentally, what is the problem you have with SYSV68_PARTITION ?
On my i586 machine, code size is 434 bytes for sysv68.o + 4 bytes more in
check.c

Philippe
