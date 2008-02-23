Return-Path: <linux-kernel-owner+w=401wt.eu-S1763343AbYBWTBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763343AbYBWTBD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760405AbYBWTAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:00:51 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:6111 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbYBWTAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:00:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pTgWlyr7fPwAvPZgcwvQSp1jD0E++DzzlTLyAkEaEPIQ+Q+ROetU1ZVIL7UD3exVIPImVvs+g5+ST+cz0P72g9gBWQMFiuhD+CrB5asvHA44+pkuZDEKhTr5qFjcb5wGOJdQykYfxeTbKln3aPvxMcHrqBeljIyAEQAJayDffeo=
Message-ID: <6101e8c40802231100t3af57018r139de0b52cd556b5@mail.gmail.com>
Date: Sat, 23 Feb 2008 20:00:48 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: 2.6.25-current-git hangs on boot
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1203789325.4063.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1203789325.4063.9.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the pci=nommconf kernel parameter helped it?

On 2/23/08, Soeren Sonnenburg <kernel@nn7.de> wrote:
> Hi,
>
> trying out newest git, I see a hang with
> ACPI: SSDT 7feb9c10, 02ae (r1 APPLE CPU0Ist 3000 intl 20050309)
> ACPI: SSDT 7feb9910, 02c3 (r1 APPLE CPU0Cst 3001 intl 20050309)
> ...
> ACPI: Processor [CPU0] (supports 8 throttling states)
> ACPI: SSDT 7feb9f10, 0087 (r1 APPLE CPU1Ist 3000 intl 20050309)
> ACPI: SSDT 7feb8f10, 0085 (r1 APPLE CPU1Cst 3001 intl 20050309)
> ...
> ACPI: ACPI0007:01 is registered as cooling_device1
> ACPI: Processor [CPU1] (supports 8 throttling states)
>
> as the last message...
>
> Any ideas?
> Soeren
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
