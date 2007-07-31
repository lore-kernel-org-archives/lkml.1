Return-Path: <linux-kernel-owner+w=401wt.eu-S1762778AbXGaOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762778AbXGaOIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759177AbXGaOIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:08:41 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:54578 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbXGaOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KErot5YyxgOtDhuSrrdYkMLieqVpdQR5RmuMpiKsTcYWZm6mvmkPyNS+UI7j9AbZJfQSJvplkorKoE2p8iFe+S6aA2IoBqaDKrqeBuDIOXhDWtPW/k5lCCjd6cGHZavjyna73O9fk3edMha7tD1D4bH30dpJ/Z6H2N8l4fQKyJQ=
Date: Tue, 31 Jul 2007 22:09:58 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: jack@hawkeye.stone.uk.eu.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch 04/16] Remove unnecessary kmalloc casts from the sparc arch.
Message-ID: <20070731140958.GA7836@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125439.789255000@hawkeye.stone.uk.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070731125439.789255000@hawkeye.stone.uk.eu.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 01:53:20PM +0100, jack@hawkeye.stone.uk.eu.org wrote:
>Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
>
>CC: David Miller <davem@davemloft.net>
>
>---
> arch/sparc/kernel/ebus.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Index: b/arch/sparc/kernel/ebus.c
>===================================================================
>--- a/arch/sparc/kernel/ebus.c
>+++ b/arch/sparc/kernel/ebus.c
>@@ -64,7 +64,7 @@ static struct ebus_device_irq *ebus_blac
>  */
> static inline unsigned long ebus_alloc(size_t size)
> {
>-	return (unsigned long)kmalloc(size, GFP_ATOMIC);
>+	return kmalloc(size, GFP_ATOMIC);

AFAIK, this cast is necessary, since void * is a pointer type while
unsigned long is not.

Regards.

-- 
To do great work, you have to have a pure mind. You can think only about the
mathematics. Everything else is human weakness. Accepting prizes is showing
weakness.

