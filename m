Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZLIVpC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZLIVpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:45:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200AbZLIVo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:44:56 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:56733 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587AbZLIVoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:44:55 -0500
Date: Wed, 9 Dec 2009 22:45:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Heinz Diehl <htd@fancy-poultry.org>
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com
Subject: Re: todays git regression (2.6.32-04008.g3ff6a46): lot of device
	mapper warnings
Message-ID: <20091209214501.GC8742@kernel.dk>
References: <200912091049.12604.borntraeger@de.ibm.com> <20091209212516.GA6206@fancy-poultry.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091209212516.GA6206@fancy-poultry.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09 2009, Heinz Diehl wrote:
> On 09.12.2009, Christian Borntraeger wrote: 
> 
> > with todays git I got a huge amount of warnings for device mapper:
> > device-mapper: uevent: version 1.0.3                                                                              
> > device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com                                  
> > device-mapper: table: 252:0: target device dasdf1 is misaligned: physical_block_size=4096, logical_block_size=4096, alignment_offset=0, start=196608                                                                                
> [...]
>  
> > The same devices produce no warning with a 2.6.32 vanilla kernel.
> 
> I have exactly the same here...

Can either one of you try and bisect it? I've cc'ed Martin, it's likely
one of the io stacking patches that causes this.

-- 
Jens Axboe

