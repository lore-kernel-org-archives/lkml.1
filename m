Return-Path: <linux-kernel-owner+w=401wt.eu-S1753945AbZIKOhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbZIKOhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:37:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbZIKOht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:37:49 -0400
Received: from bu3sch.de ([62.75.166.246]:59446 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZIKOhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:37:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 01/10] Add support for GCC-4.5's __builtin_unreachable() to compiler.h
Date: Fri, 11 Sep 2009 16:32:58 +0200
User-Agent: KMail/1.9.9
Cc: David Daney <ddaney@caviumnetworks.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-mips@linux-mips.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-s390@vger.kernel.org, linux-am33-list@redhat.com,
       Helge Deller <deller@gmx.de>, x86@kernel.org,
       Ingo Molnar <mingo@redhat.com>, Mike Frysinger <vapier@gentoo.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       uclinux-dist-devel@blackfin.uclinux.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Richard Henderson <rth@twiddle.net>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, Kyle McMartin <kyle@mcmartin.ca>,
       linux-alpha@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
References: <4AA991C1.1050800@caviumnetworks.com> <1252627011-2933-1-git-send-email-ddaney@caviumnetworks.com>
In-Reply-To: <1252627011-2933-1-git-send-email-ddaney@caviumnetworks.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909111633.00665.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 September 2009 01:56:42 David Daney wrote:
> +/* Unreachable code */
> +#ifndef unreachable
> +# define unreachable() do { for (;;) ; } while (0)
> +#endif

# define unreachable() do { } while (1)

? :)

-- 
Greetings, Michael.
