Return-Path: <linux-kernel-owner+w=401wt.eu-S1752897AbYCLSwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbYCLSwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 14:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYCLSwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 14:52:23 -0400
Received: from mail.vyatta.com ([216.93.170.194]:57073 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbYCLSwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 14:52:22 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.344
Date: Wed, 12 Mar 2008 11:52:15 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] Re: WAN: new PPP code for generic HDLC
Message-ID: <20080312115215.5fb1a370@extreme>
In-Reply-To: <m3lk4nsskh.fsf@maximus.localdomain>
References: <m3prtzsszg.fsf@maximus.localdomain>
	<m3lk4nsskh.fsf@maximus.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +struct hdlc_header {
> +	u8 address;
> +	u8 control;
> +	__be16 protocol;
> +} __attribute__ ((packed));
> +
> +struct cp_header {
> +	u8 code;
> +	u8 id;
> +	__be16 len;
> +} __attribute__ ((packed));
> +

If I remember correctly, the packed is unnecessary for structures like this
and causes GCC to generate worse code.
