Return-Path: <linux-kernel-owner+w=401wt.eu-S933118AbZJ3Xz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbZJ3Xz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 19:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933105AbZJ3XzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 19:55:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:50295 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbZJ3XzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 19:55:24 -0400
Subject: Re: Help needed, Re: [Bug #14334] pcmcia suspend regression from
 2.6.31.1 to 2.6.31.2 - Dell Inspiron 600m
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Jose Marino <braket@hotmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>
In-Reply-To: <alpine.LFD.2.01.0910301412500.31845@localhost.localdomain>
References: <Sj-rRjx6TwF.A.djE.vqe5KB@chimera>
	 <200910301948.24473.rjw@sisk.pl>
	 <alpine.LFD.2.01.0910301228430.31845@localhost.localdomain>
	 <200910302132.44759.rjw@sisk.pl>
	 <alpine.LFD.2.01.0910301335570.31845@localhost.localdomain>
	 <alpine.LFD.2.01.0910301412500.31845@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 10:54:57 +1100
Message-ID: <1256946897.6372.161.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Put another way: five years ago I would have felt that it could be 
> important that people can suspend and resume while they have a CD-ROM 
> mounted through a PCMCIA IDE card. Or something like that where you want 
> to keep session information.

I think you are a bit too much laptop centric :-) It's sadly still
common in the embedded space to use PCMCIA or Cardbus for ... root
filesystems.

Cheers,
Ben.


