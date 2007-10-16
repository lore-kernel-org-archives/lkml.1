Return-Path: <linux-kernel-owner+w=401wt.eu-S1759225AbXJPJgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225AbXJPJgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765677AbXJPJgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:36:08 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25291 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765603AbXJPJgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:36:05 -0400
Message-ID: <471485FD.2060906@panasas.com>
Date: Tue, 16 Oct 2007 11:35:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.23-git8 missing include file - [Resending the patch]
References: <471450DD.1060907@linux.vnet.ibm.com> <471459D1.5090203@linux.vnet.ibm.com>
In-Reply-To: <471459D1.5090203@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2007 09:35:58.0845 (UTC) FILETIME=[F55542D0:01C80FD7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16 2007 at 8:27 +0200, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Kamalesh Babulal wrote:
>> Hi,
>>
>> The build fails with following error
>>
>>   CC      drivers/usb/storage/scsiglue.o
>>   CC      drivers/usb/storage/protocol.o
>>   CC      drivers/usb/storage/transport.o
>> In file included from drivers/usb/storage/transport.c:53:
>> include/scsi/scsi_eh.h:79: error: field 'sense_sgl' has incomplete type
>> make[3]: *** [drivers/usb/storage/transport.o] Error 1
>> make[2]: *** [drivers/usb/storage] Error 2
>> make[1]: *** [drivers/usb] Error 2
>> make: *** [drivers] Error 2
>  
> <snip>
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
> --- linux-2.6.23/include/scsi/scsi_cmnd.h       2007-10-16 09:58:30.000000000 +0530
> +++ linux-2.6.23/include/scsi/~scsi_cmnd.h      2007-10-16 10:20:32.000000000 +0530
> @@ -5,6 +5,7 @@
>  #include <linux/list.h>
>  #include <linux/types.h>
>  #include <linux/timer.h>
> +#include <linux/scatterlist.h>
>  
>  struct request;
>  struct scatterlist;
> 
This was already fixed here:
http://www.spinics.net/lists/linux-scsi/msg20177.html

Thanks

