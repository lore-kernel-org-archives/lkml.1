Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZLCRpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZLCRpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbZLCRpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:45:30 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:49487 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbZLCRp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:45:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xR32dAad4awZSWcGh7IHoKVqgOlDXmMffKk0vr4+m3wRZ6TDepk/+Qbwk7PJO3UmIU
         tYGLcOrLfB0hk9hP9mqI3ZMB73GEy/NQO88/oZDxjaAIBtnxNXEnzlTEKnjvUQuwA9Ya
         a7PS3pKWxEDQ3HUjYJNbfzRtSnSTxFvJddJiI=
Message-ID: <4B17F93D.4030207@garzik.org>
Date: Thu, 03 Dec 2009 12:45:33 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 86/86] libata: add private driver field to struct ata_device
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171248.5446.22482.sendpatchset@localhost>
In-Reply-To: <20091125171248.5446.22482.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 12:12 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] libata: add private driver field to struct ata_device
>
> This brings struct ata_device in-line with struct ata_{port,host}.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   include/linux/libata.h |    1 +
>   1 file changed, 1 insertion(+)
>
> Index: b/include/linux/libata.h
> ===================================================================
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -585,6 +585,7 @@ struct ata_device {
>   	unsigned int		horkage;	/* List of broken features */
>   	unsigned long		flags;		/* ATA_DFLAG_xxx */
>   	struct scsi_device	*sdev;		/* attached SCSI device */
> +	void			*private_data;
>   #ifdef CONFIG_ATA_ACPI
>   	acpi_handle		acpi_handle;
>   	union acpi_object	*gtf_cache;

applied


