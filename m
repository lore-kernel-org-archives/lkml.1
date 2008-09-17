Return-Path: <linux-kernel-owner+w=401wt.eu-S1754165AbYIQI4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165AbYIQI4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYIQI4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:56:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbYIQI4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:56:16 -0400
Date: Wed, 17 Sep 2008 01:55:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Message-Id: <20080917015543.27172da4.akpm@linux-foundation.org>
In-Reply-To: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 01:27:41 -0700 Yinghai Lu <yhlu.kernel@gmail.com> wrote:

>     KERN_PCI
>     KERN_ACPI
> v4: fix some checkpatch error and warning
> v5: add default with DEFINE_LOGLEVE_SETUP_DEF
>     KERN_APIC
> v6: set the default only one time
> 
> usage:
> 	in .h to have
> 		#define KERN_PCI "<pci>"
> 	in .c to have
> 		DEFINE_LOGLEVEL_SETUP(pci, KERN_PCI, "pci:");
> 	then could use
> 		printk(KERN_DEBUG KERN_PCI fmt, ...);
> 	and command line
> 		loglevel=3,pci:8
> 
> you can add different printk to different files of one subsys if you like
> not just one susbsys one tag, and don't need to update kernel.h to add more tags

This all looks dreadfully similar to Jason Baron's "dynamic debug v2".

Similar enough that we couldn't justify merging both.
