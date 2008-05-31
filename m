Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbYFAOTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbYFAOTp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 10:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYFAORb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 10:17:31 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4403 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753186AbYFAOR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 10:17:29 -0400
Date: Sat, 31 May 2008 22:58:56 +0200
From: Pavel Machek <pavel@suse.cz>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
Message-ID: <20080531205856.GL5405@ucw.cz>
References: <20080530035620.587204923@sgi.com> <20080530040011.084909898@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080530040011.084909898@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Index: linux-2.6/mm/Kconfig
> ===================================================================
> --- linux-2.6.orig/mm/Kconfig	2008-05-29 19:41:21.000000000 -0700
> +++ linux-2.6/mm/Kconfig	2008-05-29 20:13:39.000000000 -0700
> @@ -205,3 +205,9 @@ config NR_QUICK
>  config VIRT_TO_BUS
>  	def_bool y
>  	depends on !ARCH_NO_VIRT_TO_BUS
> +
> +config CPU_ALLOC_SIZE
> +	int "Size of cpu alloc area"
> +	default "30000"
> +	help
> +	  Sets the maximum amount of memory that can be allocated via cpu_alloc

Missing . at end of line, but more important:

How do you expect user to answer this?!

I mean, can they put 0 there and expect kernel to work? If not, you
should disallow that config. And you shoudl really explain how much
memory is needed... and perhaps mention that size is in bytes?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
