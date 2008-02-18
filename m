Return-Path: <linux-kernel-owner+w=401wt.eu-S1760568AbYBRND3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760568AbYBRND3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760159AbYBRNCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:02:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40759 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760809AbYBRNB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:01:59 -0500
Date: Mon, 18 Feb 2008 05:00:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Rankin <rankincj@yahoo.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
Message-Id: <20080218050056.fb0fc0bf.akpm@linux-foundation.org>
In-Reply-To: <23590.97305.qm@web52910.mail.re2.yahoo.com>
References: <23590.97305.qm@web52910.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008 00:54:08 +0000 (GMT) Chris Rankin <rankincj@yahoo.com> wrote:

> [Try this again, except this time I'll force the attachment as inline text!]
> 
> Hi,
> 
> I have managed to boot 2.6.24.1 on this machine, with the NMI watchdog enabled, by using the
> "acpi=noirq" option. (There does seem to be some unhappiness with bridge symlinks in sysfs,
> though.)
> 

Is this a regression?  If so, which was the latest kernel version which
worked OK?

> NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> NFSD: starting 90-second grace period
> [drm] Initialized drm 1.1.0 20060810
> [drm] Initialized mga 3.2.1 20051102 on minor 0
> agpgart: Found an AGP 2.0 compliant device at 0000:00:00.0.
> agpgart: Putting AGP V2 device at 0000:00:00.0 into 4x mode
> agpgart: Putting AGP V2 device at 0000:01:00.0 into 4x mode
> [drm] Initialized card for AGP DMA.
> 

and here it hangs, I assume?

Please add initcall_debug to the kernel boot command line so we can see if
we can get a more precise idea of where it went wrong.

Do you believe that this hang is somehow caused by x86 NMI?  If so, why?

Thanks.
