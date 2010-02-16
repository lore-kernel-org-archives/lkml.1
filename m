Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933433Ab0BPXqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 18:46:12 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:40119 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757015Ab0BPXqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 18:46:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cGrA5+ACxYHHQV5qO2yXEv0lbdIi9FbmzwTeBvkOv9KBxpHMCPr+oev5uTLnvBS599
         S7Uwx91oK2R0A/39HqfspiMocjw9nctx9IeomEHW96mB6sIuewo8W7tB2eyUlccF+opQ
         aanw4adHApaqTtF/dT1Toq8cxarN8WsoLWqEA=
Message-ID: <4B7B2E44.5080202@gmail.com>
Date: Tue, 16 Feb 2010 15:46:12 -0800
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, justinmattock@gmail.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add iMac9,1 to pci_reboot_dmi_table
References: <1266362249-3337-1-git-send-email-justinmattock@gmail.com> <tip-30f541e8251d3a708544808292d96eaecbe7e3ab@git.kernel.org>
In-Reply-To: <tip-30f541e8251d3a708544808292d96eaecbe7e3ab@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 03:33 PM, tip-bot for Justin P. Mattock wrote:
> Commit-ID:  30f541e8251d3a708544808292d96eaecbe7e3ab
> Gitweb:     http://git.kernel.org/tip/30f541e8251d3a708544808292d96eaecbe7e3ab
> Author:     Justin P. Mattock<justinmattock@gmail.com>
> AuthorDate: Tue, 16 Feb 2010 15:17:29 -0800
> Committer:  H. Peter Anvin<hpa@zytor.com>
> CommitDate: Tue, 16 Feb 2010 15:26:29 -0800
>
> x86: Add iMac9,1 to pci_reboot_dmi_table
>
> On the iMac9,1 /sbin/reboot results in a black mangled screen. Adding
> this DMI entry gets the machine to reboot cleanly as it should.
>
> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> LKML-Reference:<1266362249-3337-1-git-send-email-justinmattock@gmail.com>
> Signed-off-by: H. Peter Anvin<hpa@zytor.com>
> Cc:<stable@kernel.org>
> ---
>   arch/x86/kernel/reboot.c |    8 ++++++++
>   1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 704bddc..8e1aac8 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -461,6 +461,14 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
>   			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
>   		},
>   	},
> +	{	/* Handle problems with rebooting on the iMac9,1. */
> +		.callback = set_pci_reboot,
> +		.ident = "Apple iMac9,1",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
> +		},
> +	},
>   	{ }
>   };
>
>


o.k,
I'll need to read up on what a tip-bot
is.(main thing now people can enjoy a reboot
instead of shutting down).

cheers.

Justin P. Mattock
