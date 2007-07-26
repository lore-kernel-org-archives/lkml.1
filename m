Return-Path: <linux-kernel-owner+w=401wt.eu-S1759644AbXGZCY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759644AbXGZCY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 22:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbXGZCYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 22:24:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755540AbXGZCYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 22:24:20 -0400
Date: Wed, 25 Jul 2007 19:23:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Dave Young" <hidave.darkstar@gmail.com>
Cc: "Greg KH" <gregkh@suse.de>, "Gabriel C" <nix.or.die@googlemail.com>,
       "Dave Hansen" <haveblue@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
Subject: Re: 2.6.23-rc1-mm1
Message-Id: <20070725192304.45b8d336.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0707251855u5a0a3458rfc11ac6cf649cd68@mail.gmail.com>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	<6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
	<20070725185328.GA28199@uranus.ravnborg.org>
	<46A7A1EF.8060307@zytor.com>
	<46A7B983.90407@googlemail.com>
	<46A7BB12.7060504@googlemail.com>
	<20070726000705.GB21056@suse.de>
	<20070725172845.8dec8ec5.akpm@linux-foundation.org>
	<a8e1da0707251855u5a0a3458rfc11ac6cf649cd68@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2007 01:55:03 +0000 "Dave Young" <hidave.darkstar@gmail.com> wrote:

> Hi,
> drivers/built-in.o(.text+0xc649): In function `acpi_pci_choose_state':
> : undefined reference to `acpi_pm_device_sleep_state'
> drivers/built-in.o(.text+0x3fe08): In function `pnpacpi_suspend':
> : undefined reference to `acpi_pm_device_sleep_state'
> make: *** [.tmp_vmlinux1] Error 1
> 
> The pci-acpi.c depends on CONFIG_ACPI_SLEEP

There's a hopeful-fix for this in 
ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/hot-fixes/

(will be readable in a few minutes - I had to chmod it)
