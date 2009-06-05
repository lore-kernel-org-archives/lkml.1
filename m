Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237AbZFEHLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237AbZFEHLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbZFEHLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:11:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZFEHLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:11:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header file
Date: Fri, 5 Jun 2009 08:09:07 +0100
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
References: <4A280BB0.4030805@oracle.com> <200906042228.36571.arnd@arndb.de> <4A28539B.5050200@oracle.com>
In-Reply-To: <4A28539B.5050200@oracle.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906050809.09856.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18Xh74oUqYfq+28hZQ3CJOHcOCiVDmx5sK9/WA
 x/f4D+yfriynJdAO9QeSxWPXl/z/hzrDbBGBp/I0uWiAVUCmve
 YOSRP8lZqVm24zCsNId18URAtEJhDPL
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, Randy Dunlap wrote:
> 
> > 1. The patch still conflicts with mine from the asm-generic
> > tree. Yours is better in multiple ways (cleans up all the
> > archs, adds the necessary types for ppc and arm), so should
> > I drop mine now? I guess I can also make my file identical
> > to yours so independent of who gets in first, there should be
> > a clean merge?
> 
> or you can take my patch into your asm-generic patchset.  :)

I've thought about that, but for 2.6.31, I'd like to only do
the first half of adding ~50 files to include/asm-generic/,
and then work with the arch maintainers on the second half,
removing the code from their directories for 2.6.32, so this
doesn't fit that well.

	Arnd <><
