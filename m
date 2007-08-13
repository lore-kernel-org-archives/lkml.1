Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbXHMTv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbXHMTv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbXHMTvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:51:14 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37367 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbXHMTvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:51:13 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 13 Aug 2007 15:44:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, sam@ravnborg.org,
       zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [PATCH] kconfig: update kconfig-language text
In-Reply-To: <46C0B468.8000608@oracle.com>
Message-ID: <Pine.LNX.4.64.0708131542190.15546@localhost.localdomain>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com>
 <20070813185431.GD18945@stusta.de> <Pine.LNX.4.64.0708131510140.14058@localhost.localdomain>
 <46C0B468.8000608@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Randy Dunlap wrote:

> Robert P. J. Day wrote:
> > and, as i've suggested before, it would also be cleaner to
> > remove the redundant "requires" and almost redundant "depends" from
> > Kconfig files, and standardize exclusively on "depends on".
> >
> > at the moment, there are only five Kconfig files that use the far less
> > common "depends" directive:
> >
> > ./drivers/telephony/Kconfig:    depends ISA || PCI
> > ./drivers/leds/Kconfig: depends LEDS_CLASS && ARCH_H1940
> > ./drivers/input/misc/Kconfig:   depends EXPERIMENTAL
> > ./arch/blackfin/Kconfig:        depends BFIN_DMA_5XX
> > ./arch/powerpc/platforms/Kconfig:       depends PPC_IBM_CELL_BLADE
> >
> > adjust those and there's no reason to hang on to "depends" any longer.
> >
> > rday
>
> but what problem are these?  what is solved by these changes?

why support a directive that is almost entirely unused?  sure, it's
not hurting anything, but it also has no value.  what's the point in
continuing to support obvious redundancy in the Kconfig files and the
parser?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
