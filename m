Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbXHFE5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbXHFE5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 00:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbXHFE5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 00:57:09 -0400
Received: from 207.47.19.6.static.nextweb.net ([207.47.19.6]:17137 "EHLO
	ex1.resilience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbXHFE5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 00:57:08 -0400
X-Greylist: delayed 972 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Aug 2007 00:57:08 EDT
Date: Mon, 6 Aug 2007 12:35:51 +0800
From: Jerry Jiang <wjiang@resilience.com>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why are some atomic_t's not volatile, while most are?
Message-Id: <20070806123551.a6c3c154.wjiang@resilience.com>
In-Reply-To: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
References: <Pine.LNX.4.64.0707010847370.22564@localhost.localdomain>
Organization: Resilience
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Aug 2007 04:40:44.0125 (UTC) FILETIME=[F33540D0:01C7D7E3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there some feedback on this point ?

Thank you
./Jerry

On Sun, 1 Jul 2007 08:49:37 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
>   prompted by the earlier post on "volatile"s, is there a reason that
> most atomic_t typedefs use volatile int's, while the rest don't?
> 
> $ grep "typedef.*struct"  $(find . -name atomic.h)
> ./include/asm-v850/atomic.h:typedef struct { int counter; } atomic_t;
> ./include/asm-mips/atomic.h:typedef struct { volatile int counter; } atomic_t;
> ./include/asm-mips/atomic.h:typedef struct { volatile long counter; } atomic64_t;
> ...
> 
>   etc, etc.  just curious.
> 
> rday
> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
