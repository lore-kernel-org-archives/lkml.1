Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0BOWSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 17:18:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50540 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756445Ab0BOWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 17:18:48 -0500
Message-ID: <4B79C775.1050903@zytor.com>
Date: Mon, 15 Feb 2010 14:15:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Pavel Machek <pavel@ucw.cz>, paulus@samba.org, linuxppc-dev@ozlabs.org,
       kernel list <linux-kernel@vger.kernel.org>,
       Segher Boessenkool <segher@kernel.crashing.org>, bergner@vnet.ibm.com
Subject: Re: register long sp asm("r1") incorrect
References: <20100209152444.GA30176@atrey.karlin.mff.cuni.cz>	 <1265866273.16346.34.camel@pasglop>	 <20100215073405.GB20456@atrey.karlin.mff.cuni.cz>	 <1266263992.16346.125.camel@pasglop>  <20100215202854.GA21601@elf.ucw.cz> <1266267898.16346.135.camel@pasglop>
In-Reply-To: <1266267898.16346.135.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2010 01:04 PM, Benjamin Herrenschmidt wrote:
> 
> It's true that most other use of it we have are global scope (local_paca
> in r13, glibc use of r2/r13, etc...) afaik, but since r1 itself is the
> stack pointer always, I think they pretty much guarantee it works.
> 

It should work, because r1, being the stack pointer, is already marked a
reserved register in gcc.

The reference Pavel is citing bascially states that gcc won't globally
reserve the register, which is true, but it is already reserved anyway.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
