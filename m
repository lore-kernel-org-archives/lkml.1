Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbXIAG5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbXIAG5i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 02:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXIAG5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 02:57:31 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58886 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbXIAG5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 02:57:30 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 1 Sep 2007 02:46:07 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] add-a-rounddown_pow_of_two-routine-to-log2h.patch
 fix
In-Reply-To: <200709010755.37838.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.64.0709010245440.21492@localhost.localdomain>
References: <200709010755.37838.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Sep 2007, Mariusz Kozlowski wrote:

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
>
> -

oh, crap ... how did that happen?  sorry.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
