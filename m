Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXJ2SMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXJ2SMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbXJ2SMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:12:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:54510 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbXJ2SMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:12:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=qauVN2ktnMPdK74ZjYLbGg+1blDfiW5BLi70XqJiTNc6yS+11fL1eGuRnAgaNi07b0qrlo3pHx1+kZ7ziBX28z0ZtWcI+w0SXBXN6I+Dktv/Idp3yaSbaIMr48OhPGH3pOe7xXWcHDpzeFagW1MSkb/uu5PX32t2DYBUkaci8OE=
Date: Mon, 29 Oct 2007 21:12:10 +0300
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux/interrupt.h doesn't need sched.h
Message-ID: <20071029181210.GA1822@martell.zuzino.mipt.ru>
References: <20071029134539.GB7810@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029134539.GB7810@ghostprotocols.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 11:45:39AM -0200, Arnaldo Carvalho de Melo wrote:
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -9,7 +9,6 @@
>  #include <linux/cpumask.h>
>  #include <linux/irqreturn.h>
>  #include <linux/hardirq.h>
> -#include <linux/sched.h>
>  #include <linux/irqflags.h>
>  #include <asm/atomic.h>
>  #include <asm/ptrace.h>

ACK the part that nothing needs sched.h, but it shouldn't change anything,
because of interrupt.h => hardirq.h => smp_lock.h => sched.h dependency.

[puts patch on cross-compile farm anyway]
[starts finding scalpels]
