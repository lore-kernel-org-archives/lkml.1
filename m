Return-Path: <linux-kernel-owner+w=401wt.eu-S933698AbXGYQrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbXGYQrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXGYQr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:47:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39346 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbXGYQr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:47:28 -0400
Message-ID: <46A77E92.6020902@garzik.org>
Date: Wed, 25 Jul 2007 12:47:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <p73ir88sax1.fsf@bingen.suse.de> <20070725164808.41404dc7@the-village.bc.nu> <200707251006.42948.bjorn.helgaas@hp.com>
In-Reply-To: <200707251006.42948.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> The IR driver would be the clear owner of the entire device.  Of course,
> this still only works if we get rid of the 8250 blind probe for 0x3e8
> or figure out some API for the IR driver to tell the 8250 driver to get
> its mitts off.


Load driver B before loading driver A.

	Jeff


