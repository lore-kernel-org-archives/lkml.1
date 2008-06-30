Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbYF3EOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbYF3EOe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 00:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYF3EOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 00:14:17 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:41019 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbYF3EOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 00:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZQyqI/obUDdi/1mg3c1vroDKZl+j5JNCAgFsvRlLsGd7tlk7xie8ONaUTUB8bmdtxh
         K0Vej/k9bfhDSv5irUZ6juqqMGj1qUiAyhpCeOxjuOKR2vJ50fv6jbLVob25BrOgO0p6
         dmEgq/EUagBnUt4prRl5MSR0NYM/557JOffUE=
Message-ID: <9c9fda240806292114m43d4e940h3346c03d92d65b32@mail.gmail.com>
Date: Mon, 30 Jun 2008 13:14:13 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [patch 2.6.26-rc8+] mtd: dataflash OTP support
Cc: "Bryan Wu" <cooloney@kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       linux-mtd@lists.infradead.org, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200806292019.53376.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806292019.53376.david-b@pacbell.net>
X-Google-Sender-Auth: 514b5eb821c637de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

>
> +#ifdef CONFIG_MTD_OTP
> +#define HAVE_OTP
> +#endif
> +
> +#ifdef CONFIG_MTD_ONENAND_OTP
> +#define HAVE_OTP
> +#endif
> +
> +#ifdef CONFIG_MTD_DATAFLASH_OTP
> +#define HAVE_OTP
> +#endif
> +

How about to add these at Kconfig like this,

config MTD_HAVE_OTP
         bool
         default n

and NOR, OneNAND, and DATAFLASH select MTD_HAVE_OTP if OTP support.

Thank you,
Kyungmin Park
