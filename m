Return-Path: <linux-kernel-owner+w=401wt.eu-S938498AbXHMTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938498AbXHMTV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 15:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759536AbXHMTU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 15:20:56 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36385 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761469AbXHMTUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 15:20:54 -0400
X-Originating-Ip: 72.143.66.27
Date: Mon, 13 Aug 2007 15:13:30 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Adrian Bunk <bunk@kernel.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       sam@ravnborg.org, zippel@linux-m68k.org, vincent.legoll@gmail.com
Subject: Re: [PATCH] kconfig: update kconfig-language text
In-Reply-To: <20070813185431.GD18945@stusta.de>
Message-ID: <Pine.LNX.4.64.0708131510140.14058@localhost.localdomain>
References: <20070813113809.9a715e75.randy.dunlap@oracle.com>
 <20070813185431.GD18945@stusta.de>
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

On Mon, 13 Aug 2007, Adrian Bunk wrote:

> On Mon, Aug 13, 2007 at 11:38:09AM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > Add kconfig-language docs for mainmenu, def_bool[ean],
> > and def_tristate.
> >
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
> > ---
> >  Documentation/kbuild/kconfig-language.txt |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > --- linux-2.6.23-rc3.orig/Documentation/kbuild/kconfig-language.txt
> > +++ linux-2.6.23-rc3/Documentation/kbuild/kconfig-language.txt
> > @@ -77,6 +77,11 @@ applicable everywhere (see syntax).
> >    Optionally, dependencies only for this default value can be added with
> >    "if".
> >
> > +- type definition + default value:
> > +	"def_bool"/"def_boolean"/"def_tristate" <expr> ["if" <expr>]
> >...
>
> Should the redundant and unused def_boolean be documented or removed?
>
> I'd prefer the latter.

me too.  and, as i've suggested before, it would also be cleaner to
remove the redundant "requires" and almost redundant "depends" from
Kconfig files, and standardize exclusively on "depends on".

at the moment, there are only five Kconfig files that use the far less
common "depends" directive:

./drivers/telephony/Kconfig:    depends ISA || PCI
./drivers/leds/Kconfig: depends LEDS_CLASS && ARCH_H1940
./drivers/input/misc/Kconfig:   depends EXPERIMENTAL
./arch/blackfin/Kconfig:        depends BFIN_DMA_5XX
./arch/powerpc/platforms/Kconfig:       depends PPC_IBM_CELL_BLADE

adjust those and there's no reason to hang on to "depends" any longer.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
