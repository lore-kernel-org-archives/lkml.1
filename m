Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbXJPG14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbXJPG14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 02:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761416AbXJPG1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 02:27:48 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:50230 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbXJPG1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 02:27:47 -0400
Message-ID: <471459D1.5090203@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2007 11:57:29 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.23-git8 missing include file - [Resending the patch]
References: <471450DD.1060907@linux.vnet.ibm.com>
In-Reply-To: <471450DD.1060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kamalesh Babulal wrote:
> Hi,
> 
> The build fails with following error
> 
>   CC      drivers/usb/storage/scsiglue.o
>   CC      drivers/usb/storage/protocol.o
>   CC      drivers/usb/storage/transport.o
> In file included from drivers/usb/storage/transport.c:53:
> include/scsi/scsi_eh.h:79: error: field 'sense_sgl' has incomplete type
> make[3]: *** [drivers/usb/storage/transport.o] Error 1
> make[2]: *** [drivers/usb/storage] Error 2
> make[1]: *** [drivers/usb] Error 2
> make: *** [drivers] Error 2
 
<snip>

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
--- linux-2.6.23/include/scsi/scsi_cmnd.h       2007-10-16 09:58:30.000000000 +0530
+++ linux-2.6.23/include/scsi/~scsi_cmnd.h      2007-10-16 10:20:32.000000000 +0530
@@ -5,6 +5,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/timer.h>
+#include <linux/scatterlist.h>
 
 struct request;
 struct scatterlist;

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
