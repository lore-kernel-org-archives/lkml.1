Return-Path: <linux-kernel-owner+w=401wt.eu-S1030768AbXCGAQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030768AbXCGAQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 19:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030770AbXCGAQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 19:16:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38460 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030767AbXCGAQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 19:16:09 -0500
Date: Tue, 6 Mar 2007 16:15:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas.Mailhot@LaPoste.net
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
Subject: Re: [Bug 8136] 2.6.21-rc2-mm2 won't boot
Message-Id: <20070306161559.e0c7ee71.akpm@linux-foundation.org>
In-Reply-To: <200703062336.l26NaTZA026385@fire-2.osdl.org>
References: <200703062336.l26NaTZA026385@fire-2.osdl.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 15:36:29 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=8136
> 

Let's take this to email.

> 
> 
> 
> ------- Additional Comments From Nicolas.Mailhot@LaPoste.net  2007-03-06 15:36 -------
> Created an attachment (id=10631)
>  --> (http://bugzilla.kernel.org/attachment.cgi?id=10631&action=view)
> Printscreen with vesfg disabled and earlyprintk=vga
> 

So rc2-mm2 panics due to "MP-BIOS bug: 8254 timer not connected to IO-APIC" and
rc2-mm1 does not.

Could be ACPI, could be x86_64 timer changes, could be something else.

Would you have time to bisect it? 
http://www.zip.com.au/~akpm/linux/patches/stuff/bisecting-mm-trees.txt
explains how.

If so, I'd suggest you drill in on the patches between
x86_64-mm-defconfig-update.patch and
optimize-and-simplify-get_cycles_sync.patch: the x86 changes.

