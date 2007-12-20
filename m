Return-Path: <linux-kernel-owner+w=401wt.eu-S1765877AbXLTWXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765877AbXLTWXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbXLTWX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:23:26 -0500
Received: from THUNK.ORG ([69.25.196.29]:42282 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754560AbXLTWXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:23:24 -0500
Date: Thu, 20 Dec 2007 17:22:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@shadowen.org>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, trivial@kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071220222250.GJ27081@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Joe Perches <joe@perches.com>,
	Andy Whitcroft <apw@shadowen.org>, Li Zefan <lizf@cn.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, trivial@kernel.org,
	Randy Dunlap <rdunlap@xenotime.net>,
	Joel Schopp <jschopp@austin.ibm.com>
References: <200711291120.19595.elendil@planet.nl> <20071129032036.4c021617.akpm@linux-foundation.org> <474F6372.70705@cn.fujitsu.com> <1196386259.22120.101.camel@localhost> <474F6D4D.9010006@cn.fujitsu.com> <1196390128.22120.118.camel@localhost> <20071220162923.GB27885@shadowen.org> <20071220210741.6dc3caf5@the-village.bc.nu> <1198186984.6183.72.camel@localhost> <20071220215411.183d03c0@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220215411.183d03c0@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 09:54:11PM +0000, Alan Cox wrote:
> > Kernel messages do not have to be terminated with a period.
> 
> This piece of the document is wrong. It should also be changed. I've no
> idea how such a ludicrous statement ever got into the Coding Style but I
> have never seen it discussed and an archive search suggests it just
> sneaked in without any kind of approval and discussion the list.
> 
> Kernel messages are in English. Let us keep it that way. Missing
> punctuation is equated by many parts of the English speaking world with
> poor quality, sloppy products and low levels of education. These are not
> things with which we wish to be associated IMHO.

Um, what?  Kernel messages are *not* in English.

Take a look at a machine after it is freshly booted.  The following
messages are *not* English:

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000099800 (usable)
[    0.000000]  BIOS-e820: 0000000000099800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000d6000 - 00000000000d8000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf6b0000 (usable)
[    0.000000]  BIOS-e820: 00000000bf6b0000 - 00000000bf6cc000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf6cc000 - 00000000bf700000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf700000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)

Do you really want to turn that into complete English sentences?

Or how about these?

[   15.069322] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[   15.069830] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[   15.070448] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[   15.077264] TCP: Hash tables configured (established 131072 bind 65536)
[   15.077278] TCP reno registered
[   15.086122] checking if image is initramfs... it is
[   15.846658] Freeing initrd memory: 7114k freed

Again, not sentences, and I don't think making every single printk a
gramatically valid sentence is a good thing.  Or even necessary.  And
in some cases, it would make the kernel messages harder to parse by an
automated log parser.

					- Ted
