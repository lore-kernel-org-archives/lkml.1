Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbZFEAlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbZFEAlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbZFEAlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:41:23 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:37872 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbZFEAlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:41:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tlf6Oq0CdRXdSexNSNOK3NTDFEPX/bmfhIFHlyXV4wbp74qKI9c5q47GDS+E7K4XTg
         87c2n7lFisAz0eKXm3NbHbTXyCGU9Hv+plYxlvACn9Mu3ddqm3sXCT125jBgnl4r3eOM
         eYx6zUyuMykzeTXD9K7AKwEvawvT4wqeKZaL4=
Date: Fri, 5 Jun 2009 08:43:29 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
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
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header
	file
Message-ID: <20090605004329.GA7653@cr0.nay.redhat.com>
References: <4A280BB0.4030805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A280BB0.4030805@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 11:00:16AM -0700, Randy Dunlap wrote:
>From: Randy Dunlap <randy.dunlap@oracle.com>
>Subject: kmap_types: make most arches use generic header file
>
>Convert most arches (*except frv*) to use asm-generic/kmap_types.h.
>Each arch still has its own kmap_types.h for customization if
>needed (like frv).
>
>KM_FENCE is now controlled by CONFIG_HIGHMEM.
>
>Built on x86_64, i386, mips, sparc32, sparc64,
>alpha, powerpc64, ia64, and m68k.
>
>Note: Removed KM_PTE2 from generic kmap_types.h file; it was defined
>but not used by avr32.
>
>Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>Cc: <linux-arch@vger.kernel.org>
>Acked-by: Mike Frysinger <vapier@gentoo.org>
>Cc: Richard Henderson <rth@twiddle.net>
>Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
>Cc: Bryan Wu <cooloney@kernel.org>
>Cc: Mikael Starvik <starvik@axis.com>
>Cc: Hirokazu Takata <takata@linux-m32r.org>
>Cc: "Luck Tony" <tony.luck@intel.com>
>Cc: Geert Uytterhoeven <geert@linux-m68k.org>
>Cc: Ralf Baechle <ralf@linux-mips.org>
>Cc: David Howells <dhowells@redhat.com>
>Cc: Kyle McMartin <kyle@mcmartin.ca>
>Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>Cc: Paul Mundt <lethal@linux-sh.org>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Ingo Molnar <mingo@elte.hu>
>Cc: Thomas Gleixner <tglx@linutronix.de>
>Cc: "H. Peter Anvin" <hpa@zytor.com>
>Cc: Arnd Bergmann <arnd@arndb.de>

UML only uses KM_TYPE_NR and KM_UML_USERCOPY, so
this patch should be fine for UML.

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
