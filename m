Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZHRDbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZHRDbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZHRDbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:31:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbZHRDbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:31:00 -0400
Date: Mon, 17 Aug 2009 20:30:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -mm hang while shutdown with printk_delay
Message-Id: <20090817203047.6cff48fb.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
References: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 11:25:22 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:

> Hi,
> 
> Test with printk_delay=200,
> 
> /sbin/halt -p
> 
> kernel hang after following message:
> 
> Disabling non-boot CPUs
> 
> There's no such problem with 2.6.31-rc6

umm, OK.  But -mm contains six patches:

printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix.patch
printk-boot_delay-rename-printk_delay_msec-to-loops_per_msec-fix-2.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-cleanup.patch

from yourself.  Are they the cause?
