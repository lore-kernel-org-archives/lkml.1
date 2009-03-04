Return-Path: <linux-kernel-owner+w=401wt.eu-S1754391AbZCDR6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391AbZCDR6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 12:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZCDR5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 12:57:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36300 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304AbZCDR5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 12:57:50 -0500
Date: Wed, 4 Mar 2009 18:57:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Sarah Sharp <sarah.a.sharp@intel.com>,
       Greg KH <gregkh@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-usb@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: EHCI debug documentation
Message-ID: <20090304175727.GC29823@elte.hu>
References: <20090303235354.GA7145@gamba.jf.intel.com> <86802c440903031731x36c1180dk72a3631bb4397319@mail.gmail.com> <49ADDB0B.1050002@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49ADDB0B.1050002@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Yinghai Lu wrote:
> > On Tue, Mar 3, 2009 at 3:53 PM, Sarah Sharp <sarah.a.sharp@intel.com> wrote:
> >> Greetings,
> >>
> >> You wrote the EHCI debug port patch for early printk back in July 2008
> >> (commit 5c05917e7fe313a187ad6ebb94c1c6cf42862a0b).  Can you add some
> >> documentation to the Documentation directory about how a Linux user
> >> would set up a system (cables, files to open to get the printks, etc.)?
> > 
> > please check
> > 
> > ==========================================================================================
> > USB Debug port using Howto
> > 
> > 1. HW:
> > 
> > a. target system need to have debug port
> > 
> > 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
> > EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
> >         Subsystem: Lenovo ThinkPad T61
> >         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> > ParErr- Stepping- SERR+ FastB2B- DisINTx-
> >         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
> >> TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> >         Latency: 0
> >         Interrupt: pin D routed to IRQ 19
> >         Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
> >         Capabilities: [50] Power Management version 2
> >                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> > PME(D0+,D1-,D2-,D3hot+,D3cold+)
> >                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
> >         Capabilities: [58] Debug port: BAR=1 offset=00a0
> >         Kernel driver in use: ehci_hcd
> >         Kernel modules: ehci-hcd
> > 00: 86 80 36 28 06 01 90 02 03 20 03 0c 00 00 00 00
> > 10: 00 70 22 fe 00 00 00 00 00 00 00 00 00 00 00 00
> > 20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 ab 20
> > 30: 00 00 00 00 50 00 00 00 00 00 00 00 0b 04 00 00
> > 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > 50: 01 58 c2 c9 00 80 00 00 0a 00 a0 20 00 00 00 00
> > 60: 20 20 9f 01 00 00 00 00 01 00 00 01 00 00 08 80
> > 70: c0 00 17 3f 00 00 00 00 00 00 00 00 00 00 00 00
> > 80: 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00
> > 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > d0: 00 00 00 00 00 aa ff 00 00 00 00 00 00 00 00 00
> > e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > f0: 00 00 00 00 88 85 40 00 86 0f 05 00 06 17 02 20
> > 
> > b. netchip USB debug cable
> 
> http://www.plxtech.com/products/NET2000/NET20DC/default.asp
> 
> 
> > c. console system: have USB port
> > 
> > 2. SW setting
> > a. console system: need to have kernel config
> >    CONFIG_USB_SERIAL_DEBUG
> >    you should get /dev/ttyUSBx
> > 
> >    # cat /dev/ttyUSBx could get output
> > 
> > b. target system: need to have kernel config
> >    CONFIG_EARLY_PRINTK_DBGP
> > 
> >    boot command line: earlyprintk=dbgp
> > 
> > c. for Nvidia Southbridge based system: kernel will try to probe and
> > find out which port has debug device connected.

Would be nice to turn this all into a patch that adds this info 
to Documentation/x86/early-printk.txt or so.

	Ingo
