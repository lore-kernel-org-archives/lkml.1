Return-Path: <linux-kernel-owner+w=401wt.eu-S934039AbXF2ST5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934039AbXF2ST5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXF2STs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:19:48 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58092 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbXF2STq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:19:46 -0400
Date: Fri, 29 Jun 2007 19:24:20 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Rodrigo Luiz <troops.of.doom@gmail.com>, alsa-devel@alsa-project.org,
       Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>,
       Ben Collins <bcollins@ubuntu.com>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, Tejun Heo <htejun@gmail.com>,
       Rodney Gordon II <meff@spherevision.org>
Subject: Re: [1/2] 2.6.22-rc6: known regressions v2
Message-ID: <20070629192420.0d501a93@the-village.bc.nu>
In-Reply-To: <46854B29.80906@garzik.org>
References: <46852187.3080504@googlemail.com>
	<20070629175920.6af0c62b@the-village.bc.nu>
	<468543CE.6080401@redhat.com>
	<20070629190602.4ef6a0cb@the-village.bc.nu>
	<46854B29.80906@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 14:10:49 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> >>> I'm not even sure this report is IT8212 related rather than just an IRQ
> >>> storm
> >> Why does the driver report "irq 0"?
> >>
> >> ata7: PATA max UDMA/133 cmd <blah> ctl <blah> bmdma <blah> irq 0  <====
> >>
> >> Above that, the ACPI layer says it assigned IRQ 20
> > 
> > Because the libata core code in 2.6.22rc6 reports all the ports and IRQ
> > values wrongly ?
> 
> AFAIK that was fixed, for IRQ.  Please point out examples where it 
> remains broken...

2.6.22-rc6 it is broken, for all the systems I've looked at, as are the
port numbers. Tejun posted fixes for the IRQ but they do not seem to have
been applied, or if they were it was post -rc6 to a git tree.

Alan
