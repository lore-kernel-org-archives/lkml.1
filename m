Return-Path: <linux-kernel-owner+w=401wt.eu-S1760990AbXKANLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760990AbXKANLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 09:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbXKANLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 09:11:25 -0400
Received: from ts.adaptec.com ([162.62.93.58]:55102 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbXKANLX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 09:11:23 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv2] aacraid: don't assign cpu_to_le32(constant) to u8
Date: Thu, 1 Nov 2007 09:11:32 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F958B9@otce2k301.adaptec.com>
In-Reply-To: <20071101173221.2e1fea42.sfr@canb.auug.org.au>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv2] aacraid: don't assign cpu_to_le32(constant) to u8
Thread-Index: AcgcUPde/0bAQRSsRaKu2wNakvUHCAAN6gMA
References: <20071031150216.88cecc21.sfr@canb.auug.org.au> <20071101173221.2e1fea42.sfr@canb.auug.org.au>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <linux-scsi@vger.kernel.org>, "LKML" <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK v2

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
> Sent: Thursday, November 01, 2007 2:32 AM
> To: AACRAID
> Cc: linux-scsi@vger.kernel.org; LKML
> Subject: [PATCHv2] aacraid: don't assign cpu_to_le32(constant) to u8
> 
> Noticed on PowerPC allmod config build:
> 
> drivers/scsi/aacraid/commsup.c:1342: warning: large integer 
> implicitly truncated to unsigned type
> drivers/scsi/aacraid/commsup.c:1343: warning: large integer 
> implicitly truncated to unsigned type
> drivers/scsi/aacraid/commsup.c:1344: warning: large integer 
> implicitly truncated to unsigned type
> 
> Also fix some whitespace on the changed lines.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/scsi/aacraid/commsup.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> This version just fixes a couple of whitespace anomolies on 
> the lines I
> changed.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --git a/drivers/scsi/aacraid/commsup.c 
> b/drivers/scsi/aacraid/commsup.c
> index 240a0bb..3c2dbc0 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aac)
>  			aif = (struct aac_aifcmd *)hw_fib->data;
>  			aif->command = cpu_to_le32(AifCmdEventNotify);
>  		 	aif->seqnum = cpu_to_le32(0xFFFFFFFF);
> -		 	aif->data[0] = cpu_to_le32(AifEnExpEvent);
> -			aif->data[1] = cpu_to_le32(AifExeFirmwarePanic);
> -		 	aif->data[2] = cpu_to_le32(AifHighPriority);
> +			aif->data[0] = AifEnExpEvent;
> +			aif->data[1] = AifExeFirmwarePanic;
> +			aif->data[2] = AifHighPriority;
>  			aif->data[3] = cpu_to_le32(BlinkLED);
>  
>  			/*
> -- 
> 1.5.3.4
> 
