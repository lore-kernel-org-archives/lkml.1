Return-Path: <linux-kernel-owner+w=401wt.eu-S1753196AbXLLFf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbXLLFf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 00:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXLLFfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 00:35:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752402AbXLLFft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 00:35:49 -0500
Date: Tue, 11 Dec 2007 21:33:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [patch 2/4] Add HAVE_OPROFILE
Message-Id: <20071211213345.241ce1d7.akpm@linux-foundation.org>
In-Reply-To: <20071208153934.290075585@polymtl.ca>
References: <20071208153255.078261362@polymtl.ca>
	<20071208153934.290075585@polymtl.ca>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 08 Dec 2007 10:32:57 -0500 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> @@ -21,7 +21,7 @@ config PROFILING
>  config OPROFILE
>  	tristate "OProfile system profiling (EXPERIMENTAL)"
>  	depends on PROFILING && !UML
> -	depends on ALPHA || ARM || AVR32 || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
> +	depends on HAVE_OPROFILE
>  	help
>  	  OProfile is a profiling system capable of profiling the
>  	  whole system, include the kernel, kernel modules, libraries,

So the "&& !UML" in there shold now be obsolete?  I removed it...

Ditto the one for KPROBES.
