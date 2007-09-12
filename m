Return-Path: <linux-kernel-owner+w=401wt.eu-S1763447AbXILDnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763447AbXILDnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 23:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764580AbXILDnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 23:43:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764551AbXILDnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 23:43:17 -0400
Date: Tue, 11 Sep 2007 20:43:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: Robert Day <rpjday@mindspring.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] add-a-rounddown_pow_of_two-routine-to-log2h.patch
 fix
Message-Id: <20070911204310.3d5c9312.akpm@linux-foundation.org>
In-Reply-To: <200709010755.37838.m.kozlowski@tuxland.pl>
References: <200709010755.37838.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007 07:55:36 +0200 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Hello,
> 
> 	This patch fixes the unbalanced parenthesis inroduced by
> add-a-rounddown_pow_of_two-routine-to-log2h.patch.
> 
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  include/linux/log2.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc4-mm1-a/include/linux/log2.h	2007-09-01 07:23:28.000000000 +0200
> +++ linux-2.6.23-rc4-mm1-b/include/linux/log2.h	2007-09-01 07:29:27.000000000 +0200
> @@ -186,7 +186,7 @@ unsigned long __rounddown_pow_of_two(uns
>  (						\
>  	__builtin_constant_p(n) ? (		\
>  		(n == 1) ? 0 :			\
> -		(1UL << ilog2(n)) :		\
> +		(1UL << ilog2(n))) :		\
>  	__rounddown_pow_of_two(n)		\
>   )

umm, could we get some users of this thing, preferably in some code
path which people use?
