Return-Path: <linux-kernel-owner+w=401wt.eu-S933067AbYEBJYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067AbYEBJYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758905AbYEBJYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:24:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53521 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbYEBJYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:24:04 -0400
Date: Thu, 1 May 2008 04:23:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: akpm@linux-foundation.org, jgarzik@pobox.com, muli@il.ibm.com,
       davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       bunk@kernel.org, linux-bugs@dell.com, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH] fix x86 DMI checks for PCI quirks
Message-ID: <20080501042313.4ce14c0d@infradead.org>
In-Reply-To: <20080502025427.GA23757@auslistsprd01.us.dell.com>
References: <20080502025427.GA23757@auslistsprd01.us.dell.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 21:54:27 -0500
Matt Domsch <Matt_Domsch@dell.com> wrote:
> 
> This patch moves the DMI tests into its own file, arch/x86/pci/dmi.c,
> and invokes them via subsys_initcall() before pci_acpi_init(),
> pci_legacy_init(), and pcibios_init() are called, which may rely upon
> these tests having been executed.


Hi,

can we name this file something with "quirks" in it (dmi_quirks.c or
so)? At least I tend to look for files named like that when searching
for places that do specific hardware/machine based workarounds... 

Greetings,
   Arjan van de Ven
