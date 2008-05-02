Return-Path: <linux-kernel-owner+w=401wt.eu-S934368AbYEBL4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934368AbYEBL4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759985AbYEBL4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:56:38 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:14761 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724AbYEBL4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:56:37 -0400
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-IronPort-AV:Date:From:To:Cc:Subject:Message-ID:
   References:Mime-Version:Content-Type:Content-Disposition:
   In-Reply-To:User-Agent;
  b=jH47B70FDin4U8jfs63R5jesKcDhX00+eroddahKxPTzZVFt8QdRO+9w
   DcGzTguYMrH4eZuc6Omnx/Z5i/T7s/vOiv5T/ZZDI6NC4RdTXiJCLLEi8
   MMEKhi4eAXjwaGB;
X-IronPort-AV: E=Sophos;i="4.27,426,1204524000"; 
   d="scan'208";a="34890643"
Date: Fri, 2 May 2008 06:56:11 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@linux-foundation.org, jgarzik@pobox.com, muli@il.ibm.com,
       davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       bunk@kernel.org, linux-bugs@dell.com, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] fix x86 DMI checks for PCI quirks
Message-ID: <20080502115611.GA15645@auslistsprd01.us.dell.com>
References: <20080502025427.GA23757@auslistsprd01.us.dell.com> <20080501042313.4ce14c0d@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501042313.4ce14c0d@infradead.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 04:23:13AM -0700, Arjan van de Ven wrote:
> On Thu, 1 May 2008 21:54:27 -0500
> Matt Domsch <Matt_Domsch@dell.com> wrote:
> > 
> > This patch moves the DMI tests into its own file, arch/x86/pci/dmi.c,
> > and invokes them via subsys_initcall() before pci_acpi_init(),
> > pci_legacy_init(), and pcibios_init() are called, which may rely upon
> > these tests having been executed.
> 
> 
> Hi,
> 
> can we name this file something with "quirks" in it (dmi_quirks.c or
> so)? At least I tend to look for files named like that when searching
> for places that do specific hardware/machine based workarounds... 

sure, the file name matters not much to me in this regard, and I can
see your point.

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
