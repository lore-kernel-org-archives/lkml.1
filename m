Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbXLUA13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbXLUA13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752332AbXLUA1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:27:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58116 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752791AbXLUA1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:27:19 -0500
Date: Thu, 20 Dec 2007 23:38:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Theodore Tso <tytso@mit.edu>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220233840.154c73c6@the-village.bc.nu>
In-Reply-To: <20071220222250.GJ27081@thunk.org>
References: <200711291120.19595.elendil@planet.nl>
	<20071129032036.4c021617.akpm@linux-foundation.org>
	<474F6372.70705@cn.fujitsu.com>
	<1196386259.22120.101.camel@localhost>
	<474F6D4D.9010006@cn.fujitsu.com>
	<1196390128.22120.118.camel@localhost>
	<20071220162923.GB27885@shadowen.org>
	<20071220210741.6dc3caf5@the-village.bc.nu>
	<1198186984.6183.72.camel@localhost>
	<20071220215411.183d03c0@the-village.bc.nu>
	<20071220222250.GJ27081@thunk.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Um, what?  Kernel messages are *not* in English.
> 
> Take a look at a machine after it is freshly booted.  The following
> messages are *not* English:
> 
> [    0.000000] BIOS-provided physical RAM map:
> [    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
> [    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000d6000 - 00000000000d8000 (reserved)
> [    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
> [    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
> [    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
> [    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
> [    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
> [    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
> 
> Do you really want to turn that into complete English sentences?

Properly it should have a full stop after the table.
 
> Or how about these?

> [   15.077264] TCP: Hash tables configured (established 131072 bind 65536)
                         ^Subject   ^ Verb     

> [   15.077278] TCP reno registered
                      ^ Subject ^Verb
etc

> in some cases, it would make the kernel messages harder to parse by an
> automated log parser.

Not all are sentences but many are including some of your examples, and
they should have full stops therefore.

Alan
