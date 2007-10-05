Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbXJEQ74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbXJEQ74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757533AbXJEQ7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:59:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44335 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757083AbXJEQ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:59:46 -0400
Date: Fri, 5 Oct 2007 18:01:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rob Landley <rob@landley.net>
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>,
       "Miguel Ojeda" <maxextreme@gmail.com>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Message-ID: <20071005180111.6111ccb3@the-village.bc.nu>
In-Reply-To: <200710051105.27731.rob@landley.net>
References: <1191528247.13580.11.camel@grianne>
	<200710042059.25721.rob@landley.net>
	<19f34abd0710050613y62fe6417lb47dc2bc7ad69b28@mail.gmail.com>
	<200710051105.27731.rob@landley.net>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > With the current code, localisation is not possible to do in a sane
> > way.
> 
> Run dmesg through a filter in userspace using lots of regular expressions.  
> Your average perl junkie could knock out a basic prototype in 20 minutes.

He did say "sane".

Good internationalisation requires you know where the messages are and
where the substitutions (%foo) are. So the entire operation would in fact
require

1.	An option to set "translation friendly please"

2.	A tiny modification to the snprintfoo code to support putting
some kind of marker before/after arguments and maybe doubling a symbol to
avoid vagueness

The submission is overkill compared to what is required for translation
tools and syslog.

Alan
