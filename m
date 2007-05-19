Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbXESI5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbXESI5B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 04:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754488AbXESI4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 04:56:54 -0400
Received: from www.osadl.org ([213.239.205.134]:58091 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753643AbXESI4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 04:56:53 -0400
Subject: Re: maxcpus=1 fails to boot
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-rt-users@vger.kernel.org, "lkml," <linux-kernel@vger.kernel.org>
In-Reply-To: <200705190015.53518.dvhltc@us.ibm.com>
References: <200705190015.53518.dvhltc@us.ibm.com>
Content-Type: text/plain
Date: Sat, 19 May 2007 11:02:30 +0200
Message-Id: <1179565350.12981.107.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-19 at 00:15 -0700, Darren Hart wrote:
> When trying to boot with the maxcpus=1 option, the -rt kernel seems to hang 
> somewhere in acpi_processor_init().
> 
> I tested mainline 2.6.21 and it does boot with maxcpus=1.  2.6.20-rt8, 
> 2.6.21-rt1, 2, and 4 all hang at:
> 
> Calling initcall 0xffffffff817a41df: acpi_processor_init+0x0/0xdf()
> 
> when booted with initcall_debug and maxcpus=1.  I traced this only as far as 
> the call to acpi_bus_register_driver.  So this seems to have been introduced 
> by the -rt patch.  I'm not sure if I should try and see when it was 
> introduced (as 2.6.16-rt22 does not fail) or if I should head "down the acpi 
> rabbit hole"...

Be careful, when sticking your head into this hole !

I try to nail it down. 

	tglx


