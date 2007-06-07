Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbXFGIsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbXFGIsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXFGIs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:48:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbXFGIsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:48:25 -0400
Subject: Re: 2.6.22-rc4-mm1
From: Kay Sievers <kay.sievers@vrfy.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <4667C47C.2010207@googlemail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	 <4667018D.7020407@googlemail.com> <1181168095.3612.4.camel@lov.localdomain>
	 <4667C47C.2010207@googlemail.com>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 10:48:11 +0200
Message-Id: <1181206091.3625.9.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18pu8zpViCl51nlgig+u8jD8rQuv/EPixcMCYC
 86gFpjxVenYMadT9+1sYZwXm7vYX5q5tCvZok6/ZfhfxCokMfh
 kyrXmOXqZBsJCoy04NtN10YsezNkhDN
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-07 at 10:40 +0200, Michal Piotrowski wrote:
> Kay Sievers pisze:
> > On Wed, 2007-06-06 at 20:48 +0200, Michal Piotrowski wrote:
> >> Andrew Morton pisze:
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> >>>
> >> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
> >> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
> >>
> >> Please fix it ASAP, I can't test kernel...
> > 
> > Do you have CONFIG_SYSFS_DEPRECATED set or unset?
> > 
> > Kay
> > 
> > 
> 
> cat ../linux-mm-bo/.config | grep CONFIG_SYSFS_DEPRECATED
> # CONFIG_SYSFS_DEPRECATED is not set

Oh, could you possibly try (with the block patch included) setting it to
yes and see if it works? That would help to find what's going wrong.

Thanks,
Kay

