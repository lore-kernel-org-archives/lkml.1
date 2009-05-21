Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZEUUA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZEUUA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZEUUAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:00:16 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:51422 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753847AbZEUUAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:00:15 -0400
From: Frans Pop <elendil@planet.nl>
To: Netdev <netdev@vger.kernel.org>
Subject: Re: [2.6.30] e1000e: pci_enable_pcie_error_reporting failed 0xfffffffb
Date: Thu, 21 May 2009 22:00:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
References: <200905141312.35945.elendil@planet.nl>
In-Reply-To: <200905141312.35945.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905212200.14375.elendil@planet.nl>
X-OriginalArrivalTime: 21 May 2009 20:00:14.0751 (UTC) FILETIME=[C19F32F0:01C9DA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 May 2009, Frans Pop wrote:
> With 2.6.30-rc[45] I'm always seeing this error while resuming from STR
> on my HP 2510p notebook:
>
>   e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
> ! e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
>   e1000e 0000:00:19.0: setting latency timer to 64 
>   e1000e 0000:00:19.0: wake-up capability disabled by ACPI
>   e1000e 0000:00:19.0: PME# disabled
>   e1000e 0000:00:19.0: wake-up capability disabled by ACPI
>   e1000e 0000:00:19.0: PME# disabled
>   e1000e 0000:00:19.0: irq 26 for MSI/MSI-X
>
> The error only shows up during resume, not during normal boot.
>
> With 2.6.29 the error is not present. Is this something that should be
> looked into? Networking still comes up normally.

I'm still seeing this with 2.6.30-rc6. Should I just ignore it or is it an
indication of a problem/regression?

Cheers,
FJP
