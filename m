Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXIXN3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXIXN3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:29:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbXIXN3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:29:45 -0400
Received: from atlrel7.hp.com ([156.153.255.213]:49246 "EHLO atlrel7.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbXIXN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:29:45 -0400
Message-ID: <46F7BB9E.70504@hp.com>
Date: Mon, 24 Sep 2007 09:29:02 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F7B4F2.1040506@fr.ibm.com> <46F7B735.2090509@fr.ibm.com>
In-Reply-To: <46F7B735.2090509@fr.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater wrote:
> putting Vlad in Cc: 
> 
> Cedric Le Goater wrote:
>> Andrew Morton wrote:
>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
>> I also get this compile error on s390. 'linux/scatterlist.h' has disappeared 
>> from the #include pile but where ? 
>>
>> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c: In function `sctp_auth_calculate_hmac':
>> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: error: storage size of 'sg' isn't known
>> /home/clg/linux/2.6.23-rc7-mm1/net/sctp/auth.c:695: warning: unused variable `sg'
> 
> The following patch works of course but it seems to simplistic for s390.

Odd that it didn't show up on x86 or ia64, but simple enough.

ACK.

-vlad

> 
> Cheers,
> 
> C.
> 
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> ---
>  net/sctp/auth.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: 2.6.23-rc7-mm1/net/sctp/auth.c
> ===================================================================
> --- 2.6.23-rc7-mm1.orig/net/sctp/auth.c
> +++ 2.6.23-rc7-mm1/net/sctp/auth.c
> @@ -36,6 +36,7 @@
>  
>  #include <linux/types.h>
>  #include <linux/crypto.h>
> +#include <linux/scatterlist.h>
>  #include <net/sctp/sctp.h>
>  #include <net/sctp/auth.h>
> 

