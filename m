Return-Path: <linux-kernel-owner+w=401wt.eu-S1765687AbZFQMpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765687AbZFQMpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 08:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZFQMpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 08:45:22 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:4597
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751934AbZFQMpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 08:45:21 -0400
Message-ID: <4A38E55E.7050006@panasas.com>
Date: Wed, 17 Jun 2009 15:45:18 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: Tree for June 16 (osd)
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au> <4A37CC79.5000907@oracle.com>
In-Reply-To: <4A37CC79.5000907@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jun 2009 12:45:22.0072 (UTC) FILETIME=[7A539980:01C9EF49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2009 07:46 PM, Randy Dunlap wrote:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20090615:
> 
> 
> When
> CONFIG_BLK_DEV_OSD=y
> CONFIG_SCSI_OSD_INITIATOR=y
> # CONFIG_SCSI_OSD_ULD is not set
> 
> build fails with
> 
> drivers/built-in.o: In function `class_osdblk_remove':
> osdblk.c:(.text+0x55376): undefined reference to `osduld_put_device'
> drivers/built-in.o: In function `class_osdblk_add':
> osdblk.c:(.text+0x5564d): undefined reference to `osduld_path_lookup'
> osdblk.c:(.text+0x5584d): undefined reference to `osduld_put_device'
> 
> 

Thanks, osdblk has the wrong dependency, I will fix it.

Boaz

