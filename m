Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbXA3W1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbXA3W1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXA3W1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:27:18 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54574 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbXA3W1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:27:17 -0500
Date: Tue, 30 Jan 2007 14:27:14 -0800
From: Andrew Morton <akpm@osdl.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070130142714.9f8dd5da.akpm@osdl.org>
In-Reply-To: <45BFC442.5000903@gmail.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<45BFC442.5000903@gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 23:18:42 +0100
Maciej Rutecki <maciej.rutecki@gmail.com> wrote:

> Andrew Morton napisa__(a):
> > Temporarily at
> > 
> > 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm3/
> > 
> > Will appear later at
> > 
> > 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/
> > 
> > 
> > - Restored git-block.patch: mainly the block unplugging rework.  The
> >   problematic CFQ updates have been taken out.
> > 
> > - Restored the fsaio patches as a consequence.
> > 
> > - A huge ACPI update.
> 
> I have two problems. First suspend to disk.
> 
> After suspend to disk (before resume) I check time in bios, and it's
> correct, but during resume, I have this message:
> 
> "Suspending console(s)"
> 
> system wait 20 seconds (or more) until finish resume. Also system clock
> was slow about this 20 seconds.

OK, thanks.  That might be due to the time-management updates as well. 
I'll see if I can reproduce this.

If you're keen, you could test just 2.6.19-rc6+origin.patch+git-acpi.patch
from
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/broken-out
and see which of these problems remain.


> Second problem, power button doesn't work. When I pressed it, I has this
> error:
> 
> ACPI Error (evevent-0305): No installed handler for fixed event
> [00000002] [20070126]

That sounds like an acpi regression, yup.
