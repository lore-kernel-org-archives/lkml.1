Return-Path: <linux-kernel-owner+w=401wt.eu-S1753169AbZFDXGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbZFDXGi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZFDXGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:06:30 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:52794 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbZFDXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:06:29 -0400
Message-ID: <4A28539B.5050200@oracle.com>
Date: Thu, 04 Jun 2009 16:07:07 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header
 file
References: <4A280BB0.4030805@oracle.com> <200906042228.36571.arnd@arndb.de>
In-Reply-To: <200906042228.36571.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.4A2852DD.002E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 04 June 2009, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>> Subject: kmap_types: make most arches use generic header file
>>
>> Convert most arches (*except frv*) to use asm-generic/kmap_types.h.
>> Each arch still has its own kmap_types.h for customization if
>> needed (like frv).
>>
>> KM_FENCE is now controlled by CONFIG_HIGHMEM.
>>
>> Built on x86_64, i386, mips, sparc32, sparc64,
>> alpha, powerpc64, ia64, and m68k.
>>
>> Note: Removed KM_PTE2 from generic kmap_types.h file; it was defined
>> but not used by avr32.
> 
> Every change in here looks good to me now, so
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> Two questions though:
> 
> 1. The patch still conflicts with mine from the asm-generic
> tree. Yours is better in multiple ways (cleans up all the
> archs, adds the necessary types for ppc and arm), so should
> I drop mine now? I guess I can also make my file identical
> to yours so independent of who gets in first, there should be
> a clean merge?

or you can take my patch into your asm-generic patchset.  :)

> 2. should the asm and powerpc bits go through the arch maintainer

                arm

> trees? I guess since they are slightly more than an obvious
> consolidation, at least an Ack from BenH and Russell would be
> appropriate.

Sure, acks from lots of arch maintainers would be Good,
esp. BenH and Russell.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
