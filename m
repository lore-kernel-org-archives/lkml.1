Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab0BVVVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:21:15 -0500
Received: from www.tglx.de ([62.245.132.106]:58535 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0BVVVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:21:13 -0500
Date: Mon, 22 Feb 2010 22:20:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       stanley.miao@windriver.com, Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH 10/15] MTD: nand: make reads using MTD_OOB_RAW affect
 only ECC validation
In-Reply-To: <1266863982-5258-11-git-send-email-maximlevitsky@gmail.com>
Message-ID: <alpine.LFD.2.00.1002222219430.4136@localhost.localdomain>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com> <1266863982-5258-11-git-send-email-maximlevitsky@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Maxim Levitsky wrote:

> This changes the behavier of MTD_OOB_RAW. It used to read both OOB and data
> to the data buffer, however you would still need to specify the dummy oob buffer.
> 
> This is only used in one place, but makes it hard to read data+oob without ECC
> test, thus I removed that behavier, and fixed the user.
> 
> Now MTD_OOB_RAW behaves just like MTD_OOB_PLACE, but doesn't do ECC validation

Is this tested against existing user space tools like nanddump ? Can I
still get the raw data from flash ?

Thanks,

	tglx
 
