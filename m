Return-Path: <linux-kernel-owner+w=401wt.eu-S1764919AbYD2OTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764919AbYD2OTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbYD2OQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:16:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:51661 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756060AbYD2OQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:16:01 -0400
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@osdl.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>,
       lkml Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Message-Id: <C415A4D5-CE5A-4E48-B5D5-0B9A6C7A5CA6@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
In-Reply-To: <4816C214.60806@pobox.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] devres: support addresses greater than an unsigned long via dev_ioremap
Date: Tue, 29 Apr 2008 09:08:14 -0500
References: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net> <4816C094.6030601@gmail.com> <4816C214.60806@pobox.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 29, 2008, at 1:37 AM, Jeff Garzik wrote:
> Tejun Heo wrote:
>> Kumar Gala wrote:
>>> Use a resource_size_t instead of unsigned long since some arch's are
>>> capable of having ioremap deal with addresses greater than the  
>>> size of a
>>> unsigned long.
>>>
>>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> Acked-by: Tejun Heo <htejun@gmail.com>
>
> Fine with me, too.
>
> I think devres changes should go via GregKH (device core) or Jesse  
> (PCI) rather than my libata tree, unless there are obvious  
> dependencies...

GregKH will you handle pushing this to Linus.  Its a pretty trivial  
patch and would be nice to go into 2.6.26.  I would also consider it a  
bug fix of shorts for any driver using devres and resource_size_t  
being typedef'd to u64 on a 32-bit processor.

- k
