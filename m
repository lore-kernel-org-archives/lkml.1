Return-Path: <linux-kernel-owner+w=401wt.eu-S933671AbXF2Qyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671AbXF2Qyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 12:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758869AbXF2Qym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 12:54:42 -0400
Received: from [81.2.110.250] ([81.2.110.250]:55668 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758103AbXF2Qyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 12:54:40 -0400
Date: Fri, 29 Jun 2007 17:59:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, Rodney Gordon II <meff@spherevision.org>
Subject: Re: [1/2] 2.6.22-rc6: known regressions v2
Message-ID: <20070629175920.6af0c62b@the-village.bc.nu>
In-Reply-To: <46852187.3080504@googlemail.com>
References: <46852187.3080504@googlemail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> SATA/PATA
> 
> Subject    : libata IT821X driver still fails! Hard-freezes system
> References : http://lkml.org/lkml/2007/6/14/82
> Submitter  : Rodney Gordon II <meff@spherevision.org>
> Status     : unknown

Not a regression as it seems this user's box has always been broken. I've
been running heavy testing with 2.6.22rc6 and IT8212 and its working
reliably for the "dumb" mode in question.

The hardware mode needs a fix Tejun has queued somewhere (probably in
Jeff's vast backlog) and then works too.

I'm not even sure this report is IT8212 related rather than just an IRQ
storm
