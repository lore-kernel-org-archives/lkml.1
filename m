Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbYESWuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbYESWuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbYESWun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:50:43 -0400
Received: from SOUTH-STATION-ANNEX.MIT.EDU ([18.72.1.2]:61397 "EHLO
	south-station-annex.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750899AbYESWum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:50:42 -0400
Message-ID: <20080519183654.kzsv4prunu0o40cc@webmail.mit.edu>
Date: Mon, 19 May 2008 18:36:54 -0400
From: Adam M Belay <abelay@MIT.EDU>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Adrian Bunk <bunk@kernel.org>, Rene Herman <rene.herman@gmail.com>,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>
Subject: Re: [2.6 patch] pnp: remove printk() with outdated version
References: <20080519215419.GI17716@cs181133002.pp.htv.fi>
	<200805191602.46460.bjorn.helgaas@hp.com>
In-Reply-To: <200805191602.46460.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.0.3)
X-Spam-Score: -2.599
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked.

Thanks,
Adam

Quoting Bjorn Helgaas <bjorn.helgaas@hp.com>:

> On Monday 19 May 2008 03:54:19 pm Adrian Bunk wrote:
>> There's no point in printing some ancient version number forever.
>>
>> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> Adam's the maintainer, so you really should ask him (cc'd).
> Personally, I agree that it isn't really useful anymore.
>
>> ---
>> acef517cfbe3cd741f8884311ef6fc2dfbeb1a4d diff --git 
>> a/drivers/pnp/core.c b/drivers/pnp/core.c
>> index 20771b7..d924798 100644
>> --- a/drivers/pnp/core.c
>> +++ b/drivers/pnp/core.c
>> @@ -209,7 +209,6 @@ void __pnp_remove_device(struct pnp_dev *dev)
>>
>>  static int __init pnp_init(void)
>>  {
>> -	printk(KERN_INFO "Linux Plug and Play Support v0.97 (c) Adam Belay\n");
>>  	return bus_register(&pnp_bus_type);
>>  }
>>
>>
>>
>
>
>


