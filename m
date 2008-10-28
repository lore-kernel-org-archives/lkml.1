Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYJ1B0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYJ1B0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 21:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYJ1BZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 21:25:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:17199 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYJ1BZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 21:25:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,495,1220252400"; 
   d="scan'208";a="632225140"
Subject: Re: [2.6.28-rc2] EeePC ACPI errors & exceptions
From: Zhao Yakui <yakui.zhao@intel.com>
To: Darren Salt <linux@youmustbejoking.demon.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	 <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 09:32:26 +0800
Message-Id: <1225157546.5189.73.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 15:52 -0700, Darren Salt wrote:
Will you please attach the output of acpidump?
Of course you can file a bug report at
http://bugzilla.kernel.org/enter_bug.cgi?product=ACPI
and attach the output of acpidump, dmesg.

It will be better if you can add the boot option of "printk.time=1".
thanks.

> EeePC 901, BIOS revision 1603, current Debian lenny; running on AC.
> 
> I've noticed the following errors & exceptions, apparently coinciding with
> the startup of xfce4-sensors-plugin:
> 
> ACPI: EC: missing confirmations, switch off interrupt mode.
> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for [EmbeddedControl] [20080926]
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.SBRG.EC0_.BST2] (Node f7030d38), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.CBST] (Node f70336f8), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed [\_SB_.PCI0.BAT0._BST] (Node f7031c48), AE_TIME
> ACPI Exception (battery-0360): AE_TIME, Evaluating _BST [20080926]
> 
> Also, this (which, unlike the above, is also present with 2.6.27.*):
> 
> ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region SMRG [0x400-0x40f]
> ACPI: Device needs an ACPI driver
> 
> Full dmesg & config are attached.
> 
> (The Elantech touchpad patch from http://arjan.opmeer.net/elantech/ is
> applied to this kernel.)
> 

