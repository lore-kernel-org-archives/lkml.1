Return-Path: <linux-kernel-owner+w=401wt.eu-S1762328AbZBYWEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762328AbZBYWEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbZBYWEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:04:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbZBYWEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:04:10 -0500
Message-ID: <49A5C055.70000@zytor.com>
Date: Wed, 25 Feb 2009 14:04:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Jourdan <tjourdan@interfaceconcept.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] dmi_scan_machine uses uninitialized address on x86 / EFI
References: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v>
In-Reply-To: <342F93DAA55A4EE888FBD256CE6044F4@thje6600v>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Jourdan wrote:
> Hi
> 
> On x86/EFI platforms, if efi_enabled is true, the dmi_scan_machine function
> fails, even if valid DMI table is present. In the setup_arch function,
> efi_init is called after dmi_scan_machine. But this is efi_init which will
> initialize the smbios address, needed by dmi_scan_machine.
> 
> This leads to dmi_scan_machine ioremapping physical address 0, instead of
> the address provided by the EFI system table. The following patch fixes the
> problem.
> 

Hi Thomas,

Could you please resend both this patch and the phys_efi_get_time patch 
with a Signed-off-by: line so I can apply them?

Thanks,

	-hpa
