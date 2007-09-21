Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbXIUQWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbXIUQWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 12:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbXIUQWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 12:22:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:32971 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758508AbXIUQWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 12:22:13 -0400
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Peter Fordham <peter.fordham@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: fpu IO port reservation (arch/i386)
References: <a71b7b480709210622l23481221pd09302a827b55eb@mail.gmail.com>
	<Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Sep 2007 18:22:12 +0200
In-Reply-To: <Pine.LNX.4.64N.0709211440380.2724@blysk.ds.pg.gda.pl>
Message-ID: <p73y7f07zuz.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Maciej W. Rozycki" <macro@linux-mips.org> writes:

> Hi Peter,
> 
> > Does anybody know why we reserve this range of IO ports for 'fpu'?
> > AFAIK from all the IO maps I can find on the internet for various x86
> > chipsets only 0x00f0 is actaully ever used.
> 
>  There are two ports used: 0xf0 is the busy latch reset and 0xf1 is the 
> coprocessor reset.  They are legacy ports resulting from the interesting 
> way the FPU has been wired by IBM in their PC design. 

Was it really needed on 386s? I didn't think there was a IBM 386 PC.

> None of them is 
> used by Linux for i486 and newer systems, which can support the FPU in its 
> native configuration.

I can remove it from x86-64 at least. 

-Andi
