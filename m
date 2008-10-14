Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbYJNFuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbYJNFuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYJNFuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:50:10 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:43753 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYJNFuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:50:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Z5wKdcUGx/hvOWGzHxiZpeMuagFVvYMvVzJYeMKXj5ntRaXf8z3iO8TdmlHuyiahdj
         Z+ei00EVq0Kdus2uB3sPwwItzRWUc4+pDI8aaBcc27osfXKr2x8cvtgLW/4GfgXG/N4I
         UxYeZDriAgObeBlqot+PZEB3NmNMOLuCnIHoo=
Date: Tue, 14 Oct 2008 13:50:47 +0800
From: Jianjun Kong <kongjianjun@gmail.com>
To: Simon Holm =?utf-8?B?VGjvv71nZXJzZW4=?= <odie@cs.aau.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       David Miller <davem@davemloft.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] serial: remove unused variable
Message-ID: <20081014055047.GA6552@ubuntu>
References: <1223938711.21717.16.camel@odie.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1223938711.21717.16.camel@odie.local>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 12:58:31AM +0200, Simon Holm Th�gersen wrote:
>This fixes the following compile warning:
>
>drivers/serial/8250.c: In function 'serial8250_init':
>drivers/serial/8250.c:2963: warning: unused variable 'i'
>
>that was introduced by b70ac771 (serial: allow 8250 to be used on sparc)
>that removed the last use of the variable.
>
>Signed-off-by: Simon Holm Thøgersen <odie@cs.aau.dk>
>---
> drivers/serial/8250.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
>index d4104a3..625fc20 100644
>--- a/drivers/serial/8250.c
>+++ b/drivers/serial/8250.c
>@@ -2960,7 +2960,7 @@ EXPORT_SYMBOL(serial8250_unregister_port);
> 
> static int __init serial8250_init(void)
> {
>-	int ret, i;
>+	int ret;
> 
> 	if (nr_uarts > UART_NR)
> 		nr_uarts = UART_NR;

I find those code in this function  __init serial8250_init(void)

        for (i = 0; i < NR_IRQS; i++)
                spin_lock_init(&irq_lists[i].lock);

So you do not remove the 'i'.

-- 
Jianjun Kong | Happy Hacking
HomePage: http://kongove.cn
Gtalk: kongjianjun@gmail.com
