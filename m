Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbZKWTDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbZKWTDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZKWTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:03:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54566 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZKWTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:03:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Chris Friesen" <cfriesen@nortel.com>
Subject: Re: RFC: Put printk buffer in video ram
Date: Mon, 23 Nov 2009 20:03:31 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Maxim Levitsky <maximlevitsky@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Dave Jones <davej@redhat.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linuxppc-dev@lists.ozlabs.org
References: <1258855506.3153.1.camel@maxim-laptop> <20091123183220.GB24482@elte.hu> <4B0ADA84.5050300@nortel.com>
In-Reply-To: <4B0ADA84.5050300@nortel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911232003.31482.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18A1DCViTXvSJ1I4W+5ZS780tp5F1m3juXVBu5
 sJHlM7Fzk4thpFaiv1C6fDujx9jDpj2OgPspDOLJSNhX+qbLGB
 c9/PbvI46sNSJ8x3hPa0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 November 2009, Chris Friesen wrote:
> We've had a mechanism sort of like this for quite a while.  Hasn't been
> pushed to mainline because it used board-specific hardware and we're
> usually multiple kernel versions behind mainline.
> 
> Anyways, a couple things that we've found to be useful are:
> 1) The ability to allocate a chunk of this persistent memory area for a
> special purpose.  This allows things like memory-mapped circular buffers
> for per-cpu binary data.
> 2) An API to log just to this persistent area and bypass the normal
> console completely.  This can be useful when debugging issues where the
> normal logging paths result in a hang.

Some powerpc machines have a memory-mapped nvram, in which the kernel
can install persistant 'partitions'. Not all of them are memory mapped,
but for those that are (e.g. IBM QS22), your approach sounds perfect.

	Arnd <><
