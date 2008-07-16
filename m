Return-Path: <linux-kernel-owner+w=401wt.eu-S1760241AbYGPQeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760241AbYGPQeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760215AbYGPQeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:34:03 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:37019 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760484AbYGPQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:34:00 -0400
Date: Wed, 16 Jul 2008 09:32:53 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: v2.6.26: Bad EIP value at shutdown
Message-Id: <20080716093253.f15ff3d0.randy.dunlap@oracle.com>
In-Reply-To: <19f34abd0807151844g2cdac2f7x41c2d6832339b434@mail.gmail.com>
References: <19f34abd0807151844g2cdac2f7x41c2d6832339b434@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 03:44:18 +0200 Vegard Nossum wrote:

> Hi,
> 
> My apologies for the bad report, I just got this when shutting down a
> v2.6.26, and with no camera at hand, I wrote down what I could see:
> 
> The last line of the stack dump contained the number 0xfee1dead, which
> I assume is some kind of magic number.

./linux/reboot.h:#define        LINUX_REBOOT_MAGIC1     0xfee1dead

Not especially helpful info given that stacktrace.


> The stacktrace:
> 
> notifier_call_chain
> _cpu_down
> disable_nonboot_cpus
> acpi_clear_gpe_block
> kernel_power_off
> sys_reboot
> 
> Code: Bad EIP value
> 
> So a NULL-pointer call.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
