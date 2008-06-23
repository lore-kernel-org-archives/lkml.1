Return-Path: <linux-kernel-owner+w=401wt.eu-S1752464AbYFWXx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464AbYFWXx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 19:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYFWXxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 19:53:08 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:34225 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbYFWXxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 19:53:07 -0400
Date: Tue, 24 Jun 2008 03:53:13 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: fix module load failures on smp (bug #10926)
Message-ID: <20080623235313.GA19353@jurassic.park.msu.ru>
References: <20080620232539.GA8061@jurassic.park.msu.ru> <20080623205722.GA3580@ds20.borg.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623205722.GA3580@ds20.borg.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:57:22PM +0000, Thorsten Kranzkowski wrote:
> This causes a regression for my ev4 uniprocessor build:

Doh.

> +#define PER_CPU_ATTRIBUTES
> +
>  #endif /* SMP */
>  
>  #define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
> 
> 
> Signed-off-by: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>

Acked-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Ivan.
