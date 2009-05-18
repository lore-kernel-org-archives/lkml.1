Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbZERRkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbZERRkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 13:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZERRk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 13:40:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:35130 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZERRk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 13:40:27 -0400
Message-ID: <4A119D55.4040703@kernel.org>
Date: Mon, 18 May 2009 10:39:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86: add X86_UPDATE_MPTABLE option
References: <4A0DC7DC.7000204@kernel.org> <4A0EED8B.6040704@kernel.org> <200905180941.06988.bjorn.helgaas@hp.com>
In-Reply-To: <200905180941.06988.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Saturday 16 May 2009 10:44:59 am Yinghai Lu wrote:
> 
>> +config X86_UPDATE_MPTABLE
>> +	bool "Enable update mptable according to acpi" if ACPI
>> +	default n
>> +	depends on X86_MPPARSE && ACPI
> 
> Is this any use without CONFIG_KEXEC?  Maybe it should depend on
> KEXEC as well?  Or maybe we don't need a new option at all, and
> could just put this code under CONFIG_KEXEC directly.

If ACPI is not compiled in, we don't need it that too.

> 
>> +	---help---
>> +	  some systems do not have correct mptable. with "update_mptable" or
>> +	  "alloc_mptable" kernel could try to update mptable according to DSDT.
>> +	  Then could use kexec to start second kernel (even old) without acpi
>> +	  support or "acpi=off"
> 
> Please use English conventions such as starting sentences with capital
> letters and capitalizing thing like "ACPI."

ok.

YH
