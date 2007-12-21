Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXLUMGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXLUMGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbXLUMGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:06:45 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1311 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXLUMGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:06:44 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, <joe@perches.com>,
       <davem@davemloft.net>, <apw@shadowen.org>, <lizf@cn.fujitsu.com>,
       <akpm@linux-foundation.org>, <elendil@planet.nl>, <tglx@linutronix.de>,
       <trivial@kernel.org>, <rdunlap@xenotime.net>, <jschopp@austin.ibm.com>
Subject: RE: Trailing periods in kernel messages
Date: Fri, 21 Dec 2007 04:06:06 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEHBJAAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 21 Dec 2007 04:07:47 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 21 Dec 2007 04:07:49 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jan Engelhardt wrote:

> On Dec 21 2007 17:56, Herbert Xu wrote:
> >>
> >> I do not believe "opinions" are relevant here. Relevant would be cites
> >> from respected style guides (Fowlers, Oxford Guide To Style et al.) to
> >> show they do not need a full stop.
> >>
> >> I've not found one, but I am open to references.
> >
> >Well from where I come from, full stops are only used for complete
> >sentences.
> >[...]
> >As to what is a complete sentence, that is debatable.  However,
> >typically it would include a subject and a predicate.  By this
> >rule the following line is not a complete sentence:
> >
> >	[XFS] Initialise current offset in xfs_file_readdir correctly
> >
> >The reason is that it lacks a subject.
>
> "current offset" is your subject.

I hate to have to point this out, but "current offset" is the object, not
the subject. If the sentence was, "I have initialized the current offset in
xfs_file_readdir correctly.", then it would be quite clear that "I" is the
subject and "the current offset" is the object.

The log entry has an implied subject of "I" or, if you prefer, "the kernel".
It is not a complete sentence both because it implies the subject in a
context where English does not permit that and it lacks words required by
grammar (such as the "the" before "current offset"). It also lacks a helping
verb since it should be "have initialized" (or perhaps "initialized").

Sometime you can imply the subject, such as in, "Go home!". This is not one
of those cases. You cannot say "Am sleepy" to mean "I am sleepy", even
though it would seem perfectly reasonable to allow an implied subject,
English doesn't.

There is no reason log entries should be complete sentences. If you look at
a typical log, the complete sentences generally look worse than the
fragments.

For example:

CPU: L1 I cache: 16K, L1 D cache: 16K
CPU: L2 cache: 256K
CPU serial number disabled.

and

EXT3 FS on hdc7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.

And why the inconsistency in the beginning in both these examples?

Personally, I think a mix of sentences and statements is just fine.
Sentences should end with a period when it looks worse not to.

The following extracts from my log looks perfect to me:

Switched to high resolution mode on CPU 0
lp: driver loaded but no devices found
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
agpgart: Detected VIA Apollo Pro 133 chipset
agpgart: AGP aperture is 4M @ 0xfe000000

Entries that look imperfect to me include:

ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Detected 1004.544 MHz processor.
ENABLING IO-APIC IRQs
EXT3-fs: INFO: recovery required on readonly filesystem.
Time: tsc clocksource has been installed.

The last one just looks wrong, even though it is a complete sentence.
Perhaps changing 'tsc' to 'TSC' will help or just saying "using TSC" or "TSC
enabled" would help.

Inconsistencies include:

PCI: VIA PCI bridge detected. Disabling DAC.
PCI: Enabling Via external APIC routing
pci 0000:00:04.2: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:04.2: Performing full reset

and

TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered

and

PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: f8000000-fddfffff

More important than any hard and fast rules is just how it looks. Also
important is how it looks in context. For example, with the upper case and
lower case 'pci', either way is fine, but some of each doesn't look good.
Same for 'TCP'. Why does one message have a colon and not the others?

DS


