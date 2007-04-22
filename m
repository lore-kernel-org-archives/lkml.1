Return-Path: <linux-kernel-owner+w=401wt.eu-S1030933AbXDVOqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030933AbXDVOqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030934AbXDVOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:46:17 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:62487 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030928AbXDVOqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YDHlSZMTiEal28PJL5h6wqopoS9LypTN7waWRvDdkzQsP/JlBCblfoMBVKLJDksY4mS2qXdJGhjOpTKizxxg4NzDmedCE6NC8X7Le7e4+JHcAqlKlu/P3WE72ExWcUyyHyyjpbkzEQ+VdRTnM0Ps+U8PsEJysyKiZUVYaZSHTmc=
Message-ID: <8355959a0704220746k7ffb9ba1k89695e27760e915d@mail.gmail.com>
Date: Sun, 22 Apr 2007 20:16:15 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Len Brown" <lenb@kernel.org>
Subject: Re: Linux 2.6.21-rc7 - ACPI issues? (Namespace lookup failure, AE_NOT_FOUND)
Cc: linux-acpi@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
In-Reply-To: <200704212147.47926.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8355959a0704210703n35b0dc35wcad04e5723eaec7@mail.gmail.com>
	 <200704212147.47926.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/22/07, Len Brown <lenb@kernel.org> wrote:
>
> This is an AML run-time error from a PCI Interrupt Link
> trying to find its "Present Resource Settings" --
> ie. the current IRQ for a programmable IRQ.
>
> Please open up a bug report here:
> http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI

Yep, raised a Bug report: #8360

> For 2.6.20.stable and the latest 2.6.21, please
> build with CONFIG_ACPI_DEBUG=y, and
> attach the complete output from dmesg -s64000
> and paste the /proc/interrupts.

Sure, shall test with 2.6.20.7 & 2.6.21-rc7.

> Also, please attach the output from acpidump
> and lspci -vv taken from either boot.

Shall do it ASAP ;-)

> -Len

Thanks,
~Akula2
