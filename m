Return-Path: <linux-kernel-owner+w=401wt.eu-S1757024AbXFURTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024AbXFURTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbXFURTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 13:19:12 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:4323 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876AbXFURTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 13:19:10 -0400
X-Greylist: delayed 1758 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 13:19:10 EDT
Message-ID: <467AAC2A.8020101@zankel.net>
Date: Thu, 21 Jun 2007 09:49:46 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>, Ian Molton <spyro@f2s.com>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Aubrey Li <aubrey.li@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>, Andi Kleen <ak@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, Matthew Wilcox <matthew@wil.cx>,
       Paul Mackerras <paulus@samba.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org>
In-Reply-To: <20070620230902.387008536@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy,

Could you please add the ELF architecture-magic number for Xtensa (94) 
when you finally submit this patch?

Jeremy Fitzhardinge wrote:
> This patch cleans up the ELF headers and their users.  It does several
> related things:
> --- /dev/null
> +++ b/include/linux/elf-const.h
> @@ -0,0 +1,222 @@
> +#ifndef _LINUX_ELF_CONST_H
> +#define _LINUX_ELF_CONST_H
> +
> +/* These constants define the various ELF target machines */
> +#define EM_NONE		0
...
> +#define EM_V850		87	/* NEC v850 */
> +#define EM_M32R		88	/* Renesas M32R */

#define EM_XTENSA       94

Thanks,
-Chris
