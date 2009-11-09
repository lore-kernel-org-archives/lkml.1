Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZKIIIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZKIIIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:08:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbZKIIIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:08:09 -0500
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:21927 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754058AbZKIIIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:08:05 -0500
Message-ID: <4AF7CDE7.8030008@panasas.com>
Date: Mon, 09 Nov 2009 10:08:07 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: dave@gnu.org
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] SCSI: No longer use Scsi_Cmd typedef
References: <1257711411.4759.105.camel@dbueso-pc>
In-Reply-To: <1257711411.4759.105.camel@dbueso-pc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Nov 2009 08:08:10.0670 (UTC) FILETIME=[C722CCE0:01CA6113]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2009 10:16 PM, Davidlohr Bueso wrote:
> Plenty of older drivers are still using Scsi_Cmd. The following patches
> remove its use and changes them for "struct scsi_cmnd". There is also no
> need for the drivers/scsi/scsi_typedefs.h file anymore since this only
> contains the typedef for Scsi_Cmd. 
> 
> Thanks,
> Davidlohr
> 
> 
>  drivers/scsi/NCR5380.c       |   72 ++++++++++++++++---------------
>  drivers/scsi/NCR5380.h       |   16 ++++----
>  drivers/scsi/NCR53c406a.c    |    6 +-
>  drivers/scsi/aha152x.c       |   68 +++++++++++++++---------------
>  drivers/scsi/aha1542.c       |   30 +++++++-------
>  drivers/scsi/aha1542.h       |   12 +++---
>  drivers/scsi/aha1740.c       |    8 ++--
>  drivers/scsi/aha1740.h       |    4 +-
>  drivers/scsi/atari_NCR5380.c |   94 +++++++++++++++++++++---------------------
>  drivers/scsi/atari_scsi.c    |   12 +++---
>  drivers/scsi/atari_scsi.h    |    2 +-
>  drivers/scsi/dtc.h           |    6 +-
>  drivers/scsi/fd_mcs.c        |   10 ++--
>  drivers/scsi/g_NCR5380.c     |   10 ++--
>  drivers/scsi/g_NCR5380.h     |    6 +-
>  drivers/scsi/gdth.c          |   66 +++++++++++++++---------------
>  drivers/scsi/gdth.h          |   10 ++--
>  drivers/scsi/gdth_proc.c     |    2 +-
>  drivers/scsi/ibmmca.c        |   28 ++++++------
>  drivers/scsi/in2000.c        |   68 +++++++++++++++---------------
>  drivers/scsi/in2000.h        |   14 +++---
>  drivers/scsi/megaraid.c      |   28 ++++++------
>  drivers/scsi/megaraid.h      |   18 ++++----
>  drivers/scsi/nsp32_debug.c   |    2 +-
>  drivers/scsi/pas16.h         |    6 +-
>  drivers/scsi/scsi.h          |    3 -
>  drivers/scsi/sym53c416.c     |    6 +-
>  drivers/scsi/sym53c416.h     |    4 +-
>  drivers/scsi/wd7000.c        |    2 +-
>  29 files changed, 306 insertions(+), 307 deletions(-)
> 

Thanks for doing this. What a grate relief.

One thing that I'm missing is the actual patch to remove the
scsi_typedefs.h file. Is it still used?

Thanks
Boaz
