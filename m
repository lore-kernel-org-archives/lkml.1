Return-Path: <linux-kernel-owner+w=401wt.eu-S933360AbZJaXIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbZJaXIk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 19:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbZJaXIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 19:08:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59395 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933320AbZJaXIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 19:08:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
Date: Sun, 1 Nov 2009 00:10:07 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera> <200910312227.15493.rjw@sisk.pl> <1257029775.7907.21.camel@pasglop>
In-Reply-To: <1257029775.7907.21.camel@pasglop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911010010.07394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 October 2009, Benjamin Herrenschmidt wrote:
> On Sat, 2009-10-31 at 22:27 +0100, Rafael J. Wysocki wrote:
> 
> > In the meantime I invented a patch that works, ie. apparently fixes the problem
> > and if there was a card in the socket during the suspend, it's standard config
> > space is restored correctly.  I tested it on one of my boxes with two different
> > CardBus adapters and Jose says it fixes the problem for him.
> > 
> > The patch is appended, please have a look.
> 
> Base idea of the patch sounds good, quick browse through looks good too,
> 
> I'll try to band on it with various PCMCIA & CB gear tomorrow.

Wait, I made a mistake when testing it, didn't notice that my distro ejected
PCMCIA cards automatically before suspend (sigh).

Working on a better patch right now, will hopefully post it in a while.

Thanks,
Rafael
