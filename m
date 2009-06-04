Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFDVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFDVcb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:32:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbZFDVbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:31:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755595AbZFDVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:31:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header file
Date: Thu, 4 Jun 2009 22:28:34 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Luck Tony <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <rmk@arm.linux.org.uk>
References: <4A280BB0.4030805@oracle.com>
In-Reply-To: <4A280BB0.4030805@oracle.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906042228.36571.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1++02lifIKbqjxQOqu07ldjHsc4LOEqFMxb6De
 /Z7bHh5YAC14GGReIQU6v4OHDxSFn3qZpDZsUFphqFIpWlg0bq
 eKFSan7gRCOYHPAjvm3Vw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Subject: kmap_types: make most arches use generic header file
> 
> Convert most arches (*except frv*) to use asm-generic/kmap_types.h.
> Each arch still has its own kmap_types.h for customization if
> needed (like frv).
> 
> KM_FENCE is now controlled by CONFIG_HIGHMEM.
> 
> Built on x86_64, i386, mips, sparc32, sparc64,
> alpha, powerpc64, ia64, and m68k.
> 
> Note: Removed KM_PTE2 from generic kmap_types.h file; it was defined
> but not used by avr32.

Every change in here looks good to me now, so

Acked-by: Arnd Bergmann <arnd@arndb.de>

Two questions though:

1. The patch still conflicts with mine from the asm-generic
tree. Yours is better in multiple ways (cleans up all the
archs, adds the necessary types for ppc and arm), so should
I drop mine now? I guess I can also make my file identical
to yours so independent of who gets in first, there should be
a clean merge?

2. should the asm and powerpc bits go through the arch maintainer
trees? I guess since they are slightly more than an obvious
consolidation, at least an Ack from BenH and Russell would be
appropriate.

	Arnd <><
