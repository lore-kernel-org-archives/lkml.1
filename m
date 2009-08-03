Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbZHCRkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbZHCRkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZHCRkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:40:23 -0400
Received: from lider.uludag.org.tr ([193.140.100.216]:33124 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZHCRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:40:22 -0400
Message-ID: <4A772105.6060101@pardus.org.tr>
Date: Mon, 03 Aug 2009 20:40:21 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Add quirk to make Apple MacBook5,2 use
 reboot=pci
References: <19062.56420.501516.316181@cargo.ozlabs.ibm.com> <tip-1961b971360c685e15dff59929c39ced6c46e171@git.kernel.org>
In-Reply-To: <tip-1961b971360c685e15dff59929c39ced6c46e171@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tip-bot for Paul Mackerras wrote:
> Commit-ID:  1961b971360c685e15dff59929c39ced6c46e171
> Gitweb:     http://git.kernel.org/tip/1961b971360c685e15dff59929c39ced6c46e171
> Author:     Paul Mackerras <paulus@samba.org>
> AuthorDate: Mon, 3 Aug 2009 22:47:32 +1000
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 3 Aug 2009 08:07:18 -0700
>
> x86: Add quirk to make Apple MacBook5,2 use reboot=pci
>
> The latest Apple MacBook (MacBook5,2) doesn't reboot successfully
> under Linux; neither the EFI reboot method nor the default method
> using the keyboard controller works (the system just hangs and doesn't
> reset).  However, the method using the "PCI reset register" at 0xcf9
> does work.
>
> This adds a quirk to detect this machine via DMI and force the
> reboot_type to BOOT_CF9.  With this it reboots successfully without
> requiring a command-line option.  Note that the EFI code forces
> reboot_type to BOOT_EFI when the machine is booted via EFI, but this
> overrides that since the core_initcall runs after the EFI
> initialization code.
>   

MacBookPro5,1 has also this problem. I booted with reboot=pci on
2.6.30.4 and now it rebooted without problem.
That would be nice if you could add another quirk entry for it:

System Information
        Manufacturer: Apple Inc.
        Product Name: MacBookPro5,1

Thanks!
Ozan Caglayan
