Return-Path: <linux-kernel-owner+w=401wt.eu-S935801AbXJPULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935801AbXJPULl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935613AbXJPULS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:11:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18677 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935576AbXJPULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:11:16 -0400
Date: Tue, 16 Oct 2007 13:06:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kexec@lists.infradead.org
Subject: Re: kexec: Cannot determine the file type of arch/x86/boot/bzImage
Message-Id: <20071016130657.8cc17011.randy.dunlap@oracle.com>
In-Reply-To: <47151631.9000307@m3y3r.de>
References: <47151631.9000307@m3y3r.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 21:51:13 +0200 Thomas Meyer wrote:

[adding kexec mailing list]


> Hi.
> 
> Look at this:
> 
> $ file arch/x86/boot/bzImage (tree 821f3eff7cdb9d6c7076effabd46c96c322daed1)
> arch/x86/boot/bzImage: Linux kernel x86 boot executable zImage, version
> 2.6.23 (thomas@hotzenplotz) #39, RO-rootFS, root_dev 0x803, swap_dev
> 0x1, Prompt for Videomode
> 
> $ file /boot/bzImage-2.6.23
> /boot/bzImage-2.6.23: Linux kernel x86 boot executable RO-rootFS,
> root_dev 0x803, swap_dev 0x1, Normal VGA
> 
> and this:
> 
> # kexec -l arch/x86/boot/bzImage
> Cannot determine the file type of arch/x86/boot/bzImage
> 
> How to solve this error?
> 
> mfg
> thomas
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
