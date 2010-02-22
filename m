Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0BVVd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:33:29 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60949 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab0BVVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:33:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZOiIx+h4JVJgzUIs+iydOENmTA+FFWi1+vLRhpAdxnVNfDmL9ffcF7tSDYWrHN6nep
         oQmQttYYgGWB5+GbuTzvOc7ffUoF9tjQ5IUfxH/3m5SB5zcW6IlbbzuAuU7O+8Zl5lzA
         qSYFExKKIe6mmWlXBT4r4yHg+Z3UnDerx32Ic=
Subject: Re: [PATCH 13/15] MTD: add few workarounds to nand system for
 SmartMedia/xD chips.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       stanley.miao@windriver.com, Vitaly Wool <vitalywool@gmail.com>
In-Reply-To: <alpine.LFD.2.00.1002222223090.4136@localhost.localdomain>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com>
	 <1266863982-5258-14-git-send-email-maximlevitsky@gmail.com>
	 <alpine.LFD.2.00.1002222223090.4136@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Feb 2010 23:33:22 +0200
Message-ID: <1266874402.4971.9.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-22 at 22:25 +0100, Thomas Gleixner wrote: 
> On Mon, 22 Feb 2010, Maxim Levitsky wrote:
> 
> > * Add an option NAND_SMARTMEDIA that can be set by nand driver
> >  If set, it will cause separate ID table to be used, which includes
> >  mask rom devices and new xD cards
> 
> Why that option ? We can just extend the existing ids table and be
> done. No extra magic needed.
>  

Two reasons.

First of all several xD chips (I belive the Type M) have exactly same
IDs like normal nand chips. However they don't report capabilities about
pagesize, blocksize, etc.

I am confident that these cards have an internal FTL and controller, and
just 'emulate' that nand interface.

Also, my card  reports write protect, although, xD cards don't have any
'switch' to make them protected.
Even if there were readonly ROM xD cards (the odds of this are virtually
zero), these won't just expose this in WP bit.

Best regards,
Maxim Levitsky


