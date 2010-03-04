Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab0CDAS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 19:18:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43270 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555Ab0CDASU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 19:18:20 -0500
Message-ID: <4B8EFC2A.8070303@zytor.com>
Date: Wed, 03 Mar 2010 16:17:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Daniel Taylor <Daniel.Taylor@wdc.com>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] msdos: add support for large disks
References: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD2D@wdscexbe01.sc.wdc.com><20100301141335.395dc4c3.akpm@linux-foundation.org> <873a0h1p2c.fsf@devron.myhome.or.jp> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD53@wdscexbe01.sc.wdc.com> <4B8EEB2D.4090106@zytor.com> <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD56@wdscexbe01.sc.wdc.com>
In-Reply-To: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD56@wdscexbe01.sc.wdc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 03:24 PM, Daniel Taylor wrote:
> 
> Those are good points.  We (WD) are trying to get the NDAs, regarding our
> specific not-yet-released products, in place to get the userspace utilities
> updated, and WD is also in communication with the Windows tool developers.
> 
> Fundamentally, though, the way Windows XP, which only supports MBR
> partitioning, can use a disk drive capacity larger than 2 TiB is with sector
> sizes larger than 512 bytes.  That is far too large a slice of the installed
> base for the disk drive makers to ignore, so these drives and partitions are
> going to be released, whether by WD, or someone else.  When someone plugs
> one of these disks into a system running Linux, we don't need to hear about
> "Linux doesn't support it", if there's a reasonable accomodation.  In this
> case, both the inputs MBR partitioning, and the data stored as a result, are
> fully capable.  It is only the intermediate variables in the module that are
> currently hard-coded to 32-bits, and which truncate the values.
> 

I should probably clarify that I was not, in any way, objecting to the
patch; quite on the contrary.

	-hpa

