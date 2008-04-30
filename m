Return-Path: <linux-kernel-owner+w=401wt.eu-S933427AbYD3Vun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbYD3Vun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 17:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbYD3Vt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 17:49:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:42875 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762838AbYD3Vt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 17:49:57 -0400
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@osdl.org>, htejun@gmail.com,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Emilian.Medve@Freescale.com, linuxppc-dev@ozlabs.org
Message-Id: <F4E7A0B8-894F-4903-855E-6A4BE63CF8D5@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: benh@kernel.crashing.org
In-Reply-To: <1209591750.18023.233.camel@pasglop>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH v2] [POWERPC] devres: Add devm_ioremap_flags()
Date: Wed, 30 Apr 2008 16:49:05 -0500
References: <Pine.LNX.4.64.0804301106010.22992@blarg.am.freescale.net> <1209591750.18023.233.camel@pasglop>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30, 2008, at 4:42 PM, Benjamin Herrenschmidt wrote:
>
> On Wed, 2008-04-30 at 11:08 -0500, Kumar Gala wrote:
>> From: Emil Medve <Emilian.Medve@Freescale.com>
>>
>> We provide an ioremap_flags so provide a coresphonding  
>> devm_ioremap_flags.
>>
>> Signed-off-by: Emil Medve <Emilian.Medve@Freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>>
>> Forgot to commit the actual implemtation in arch/powerpc/lib/devres.c
>>
>> Which tree should this go through, powerpc.git?
>
> Let's call it ioremap_prot instead please. I'm about to change
> ioremap_flags to ioremap_prot anyways. Keep the flags/prot argument
> unsigned long for now (it can be argued it should be a pgprot but that
> hasn't been sorted out completely).

No problem.  I've always wondered why ioremap_* aren't better  
specified by generic code.

- k

