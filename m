Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706Ab0AGTPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706Ab0AGTPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:15:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642Ab0AGTPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:15:19 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:42571 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab0AGTPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:15:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YM7WgBWtlKpW/Pdef75j0+lLD1+tyu+QpUMa/qrMW2dQDs0AOHnSX2pxQm2cU+tsvz
         q3830pR+HlHE9nGy/n0TMlpeYAFNUc1ld4D9yq3nIRqzHaFql5zX57t/5M08qMGicwJk
         WtYaH48VVHc/IFq0eRIzsXCPNJohLDioJRRBI=
Message-ID: <4B4632BF.4070806@pobox.com>
Date: Thu, 07 Jan 2010 14:15:11 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
References: <4B3BDB66.6000008@googlemail.com>
In-Reply-To: <4B3BDB66.6000008@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 05:59 PM, René Bolldorf wrote:
> We don't need this ;-).
>
> Best regards René Bolldorf & a happy new year in advance.
>
> --- ./drivers/ata/libata-eh.c 2009-12-30 23:44:05.578988545 +0100
> +++ ./drivers/ata/libata-eh.c 2009-12-30 23:45:06.991987607 +0100
> @@ -1505,9 +1505,6 @@ static unsigned int atapi_eh_request_sen
>
> DPRINTK("ATAPI request sense\n");
>
> - /* FIXME: is this needed? */
> - memset(sense_buf, 0, SCSI_SENSE_BUFFERSIZE);

I need a little bit more detail than an unqualified statement...  Did 
you audit all paths leading to this code point?

	Jeff


