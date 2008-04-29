Return-Path: <linux-kernel-owner+w=401wt.eu-S932552AbYD2P0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552AbYD2P0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbYD2P0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:26:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46840 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbYD2P0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:26:36 -0400
Date: Tue, 29 Apr 2008 08:23:31 -0700
From: Greg KH <greg@kroah.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       Andrew Morton <akpm@osdl.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>,
       lkml Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] devres: support addresses greater than an unsigned
	long via dev_ioremap
Message-ID: <20080429152331.GC11329@kroah.com>
References: <Pine.LNX.4.64.0804290122210.10928@blarg.am.freescale.net> <4816C094.6030601@gmail.com> <4816C214.60806@pobox.com> <C415A4D5-CE5A-4E48-B5D5-0B9A6C7A5CA6@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C415A4D5-CE5A-4E48-B5D5-0B9A6C7A5CA6@kernel.crashing.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 09:08:14AM -0500, Kumar Gala wrote:
>
> On Apr 29, 2008, at 1:37 AM, Jeff Garzik wrote:
>> Tejun Heo wrote:
>>> Kumar Gala wrote:
>>>> Use a resource_size_t instead of unsigned long since some arch's are
>>>> capable of having ioremap deal with addresses greater than the size of a
>>>> unsigned long.
>>>>
>>>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>>> Acked-by: Tejun Heo <htejun@gmail.com>
>>
>> Fine with me, too.
>>
>> I think devres changes should go via GregKH (device core) or Jesse (PCI) 
>> rather than my libata tree, unless there are obvious dependencies...
>
> GregKH will you handle pushing this to Linus.  Its a pretty trivial patch 
> and would be nice to go into 2.6.26.  I would also consider it a bug fix of 
> shorts for any driver using devres and resource_size_t being typedef'd to 
> u64 on a 32-bit processor.

Sure, I'd be glad to.  But I don't see the patch, care to resend it to
me?

thanks,

greg k-h
