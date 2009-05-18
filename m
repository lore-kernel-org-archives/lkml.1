Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZERPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZERPlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 11:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbZERPlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 11:41:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:22028 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbZERPlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 11:41:10 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86: add X86_UPDATE_MPTABLE option
Date: Mon, 18 May 2009 09:41:05 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
References: <4A0DC7DC.7000204@kernel.org> <4A0EED8B.6040704@kernel.org>
In-Reply-To: <4A0EED8B.6040704@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905180941.06988.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 May 2009 10:44:59 am Yinghai Lu wrote:

> +config X86_UPDATE_MPTABLE
> +	bool "Enable update mptable according to acpi" if ACPI
> +	default n
> +	depends on X86_MPPARSE && ACPI

Is this any use without CONFIG_KEXEC?  Maybe it should depend on
KEXEC as well?  Or maybe we don't need a new option at all, and
could just put this code under CONFIG_KEXEC directly.

> +	---help---
> +	  some systems do not have correct mptable. with "update_mptable" or
> +	  "alloc_mptable" kernel could try to update mptable according to DSDT.
> +	  Then could use kexec to start second kernel (even old) without acpi
> +	  support or "acpi=off"

Please use English conventions such as starting sentences with capital
letters and capitalizing thing like "ACPI."

Bjorn
