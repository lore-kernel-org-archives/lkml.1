Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab0BDGNW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 01:13:22 -0500
Received: from mail-yx0-f189.google.com ([209.85.210.189]:47591 "EHLO
	mail-yx0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab0BDGNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 01:13:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Rt1ND25C9r15Ec5hm5Yn8C5fpHsK/yWbtIqV2PLPCiM+MA4EvSXz6BQFYsqKZJX+8S
         fK6MKKNMW5j/Oh1Mx5cA+RtU7VDzbAk3cB7WMFFxGZZy5HCx7Ef7bWkvO0p1fP3/yBDS
         AW1wnTxw+jIJlSKeKcWzqCklgwQ4rTAVs21jQ=
Message-ID: <4B6A657E.4050408@pobox.com>
Date: Thu, 04 Feb 2010 01:13:18 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Emese Revfy <re.emese@gmail.com>
CC: lenb@kernel.org, bjorn.helgaas@hp.com, jbarnes@virtuousgeek.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Constify struct acpi_dock_ops for v2.6.33-rc6
References: <4B65D72B.8070000@gmail.com>
In-Reply-To: <4B65D72B.8070000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2010 02:16 PM, Emese Revfy wrote:
> From: Emese Revfy<re.emese@gmail.com>
>
> Constify struct acpi_dock_ops.
>
> This is part of the ops structure constification
> effort started by Arjan van de Ven et al.
>
> Benefits of this constification:
>
>   * prevents modification of data that is shared
>     (referenced) by many other structure instances
>     at runtime
>
>   * detects/prevents accidental (but not intentional)
>     modification attempts on archs that enforce
>     read-only kernel data at runtime
>
>   * potentially better optimized code as the compiler
>     can assume that the const data cannot be changed
>
>   * the compiler/linker move const data into .rodata
>     and therefore exclude them from false sharing
>
> Signed-off-by: Emese Revfy<re.emese@gmail.com>
> ---
>
>   drivers/acpi/dock.c                |    4 ++--
>   drivers/ata/libata-acpi.c          |    4 ++--
>   drivers/pci/hotplug/acpiphp_glue.c |    2 +-
>   include/acpi/acpi_drivers.h        |    4 ++--
>   4 files changed, 7 insertions(+), 7 deletions(-)

Acked-by: Jeff Garzik <jgarzik@redhat.com>


