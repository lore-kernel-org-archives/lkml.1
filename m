Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab0BVV0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 16:26:04 -0500
Received: from www.tglx.de ([62.245.132.106]:58172 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab0BVV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 16:26:00 -0500
Date: Mon, 22 Feb 2010 22:25:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
cc: David Woodhouse <dwmw2@infradead.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       stanley.miao@windriver.com, Vitaly Wool <vitalywool@gmail.com>
Subject: Re: [PATCH 13/15] MTD: add few workarounds to nand system for
 SmartMedia/xD chips.
In-Reply-To: <1266863982-5258-14-git-send-email-maximlevitsky@gmail.com>
Message-ID: <alpine.LFD.2.00.1002222223090.4136@localhost.localdomain>
References: <1266863982-5258-1-git-send-email-maximlevitsky@gmail.com> <1266863982-5258-14-git-send-email-maximlevitsky@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Feb 2010, Maxim Levitsky wrote:

> * Add an option NAND_SMARTMEDIA that can be set by nand driver
>  If set, it will cause separate ID table to be used, which includes
>  mask rom devices and new xD cards

Why that option ? We can just extend the existing ids table and be
done. No extra magic needed.
 
Thanks,

	tglx
