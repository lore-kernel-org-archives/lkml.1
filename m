Return-Path: <linux-kernel-owner+w=401wt.eu-S934375AbYEBRL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934375AbYEBRL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbYEBRLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:11:47 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54034 "EHLO
	outbound2-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbYEBRLq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:11:46 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [2.6 patch] char/xilinx_hwicap/ section fix
Date: Fri, 2 May 2008 09:50:05 -0700
In-reply-to: <20080423095138.GA28933@cs181133002.pp.htv.fi>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [2.6 patch] char/xilinx_hwicap/ section fix
Thread-Index: AcilJ72mZi5+WogRTZyYc6WtqJ1CxgHTJc0g
References: <20080423095138.GA28933@cs181133002.pp.htv.fi>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Adrian Bunk" <bunk@kernel.org>,
       "Grant Likely" <grant.likely@secretlab.ca>, <paulus@samba.org>
Cc: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 16:50:06.0993 (UTC) FILETIME=[93717810:01C8AC74]
Message-Id: <20080502165007.16B3F170006C@mail22-sin.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>

Grant, please pick this up.

Steve

> -----Original Message-----
> From: Adrian Bunk [mailto:bunk@kernel.org]
> Sent: Wednesday, April 23, 2008 2:52 AM
> To: Stephen Neuendorffer; Grant Likely; paulus@samba.org
> Cc: linuxppc-dev@ozlabs.org; linux-kernel@vger.kernel.org
> Subject: [2.6 patch] char/xilinx_hwicap/ section fix
> 
> This patch fixes the following build error:
> 
> <--  snip  -->
> 
> ...
>   CC [M]  drivers/char/xilinx_hwicap/xilinx_hwicap.o
> ...
>
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/xilinx_hwicap/xil
inx_hwicap.c:806: error:
> hwicap_of_match causes a section type conflict
>
/home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/char/xilinx_hwicap/xil
inx_hwicap.c:806: error:
> hwicap_of_match causes a section type conflict
> make[4]: *** [drivers/char/xilinx_hwicap/xilinx_hwicap.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 2f0f31d8aa696ca6cc45ab865ec8c68b90cd0e46 diff --git
a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> index 016f905..dfe6907 100644
> --- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> +++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> @@ -803,7 +803,7 @@ static int __devexit hwicap_of_remove(struct
of_device *op)
>  }
> 
>  /* Match table for of_platform binding */
> -static const struct of_device_id __devinit hwicap_of_match[] = {
> +static const struct of_device_id __devinitconst hwicap_of_match[] = {
>  	{ .compatible = "xlnx,opb-hwicap-1.00.b", .data =
&buffer_icap_config},
>  	{ .compatible = "xlnx,xps-hwicap-1.00.a", .data =
&fifo_icap_config},
>  	{},
> 


