Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbXHBLxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbXHBLxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 07:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXHBLx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 07:53:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34896 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbXHBLxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 07:53:25 -0400
Date: Thu, 2 Aug 2007 12:59:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: trenn@suse.de, Adrian =?UTF-8?B?U2NocsO2dGVy?= <adrian@suse.de>,
       Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, lenb@kernel.org,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802125947.4a1ff933@the-village.bc.nu>
In-Reply-To: <20070802111327.GA29002@srcf.ucam.org>
References: <46B1988C.3090302@t-online.de>
	<1186047747.18821.450.camel@queen.suse.de>
	<200708021145.09377.adrian@suse.de>
	<1186048701.18821.459.camel@queen.suse.de>
	<20070802120221.5474e732@the-village.bc.nu>
	<20070802111327.GA29002@srcf.ucam.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I strongly suspect that the vast majority[1] of hardware that "needs" 
> the trip points changing works perfectly well under Windows, so it's 

Windows as I understand it has vendor mechanisms to allow the bits
shipped with the OS to override/ignore just about everything trip points
included. Lots of hardware that requires fixups in Linux and just works
in Windows is not Linux bugs but Windows magic .inf files and other
registry gunge done by the machine vendor. We see this in ATA, in power
management and elsewhere.

Alan
