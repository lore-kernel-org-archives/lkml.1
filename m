Return-Path: <linux-kernel-owner+w=401wt.eu-S933340AbZJaW4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340AbZJaW4i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 18:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933326AbZJaW4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 18:56:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:43215 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933294AbZJaW4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 18:56:32 -0400
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
In-Reply-To: <200910312227.15493.rjw@sisk.pl>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <200910311031.17660.rjw@sisk.pl> <1257022890.7907.14.camel@pasglop>
	 <200910312227.15493.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 01 Nov 2009 09:56:15 +1100
Message-ID: <1257029775.7907.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-31 at 22:27 +0100, Rafael J. Wysocki wrote:

> In the meantime I invented a patch that works, ie. apparently fixes the problem
> and if there was a card in the socket during the suspend, it's standard config
> space is restored correctly.  I tested it on one of my boxes with two different
> CardBus adapters and Jose says it fixes the problem for him.
> 
> The patch is appended, please have a look.

Base idea of the patch sounds good, quick browse through looks good too,

I'll try to band on it with various PCMCIA & CB gear tomorrow.

Cheers,
Ben.


