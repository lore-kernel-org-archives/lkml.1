Return-Path: <linux-kernel-owner+w=401wt.eu-S1756459AbZEER6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459AbZEER6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZEER5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:57:50 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:54851 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753151AbZEER5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:57:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BC9N3/QxNo+A7Qd07XxDMjfkHy/Mm9rjKFQMs5TPAWO59UKZi/0b0lOnrC717XHeHU5dTss/N8zUoZQC/41GzbXbsrdUKRQ8A/pV2Zs6jef+TzprBfWLKwz5ePrVLOLl;
Date: Tue, 5 May 2009 10:57:44 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ed Swierk <eswierk@aristanetworks.com>
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [RFC] [PATCH] PCI mmconfig without ACPI
Message-ID: <20090505105744.4268e341@hobbes>
In-Reply-To: <1234812741.28801.4.camel@localhost.localdomain>
References: <1233766786.16414.26.camel@localhost.localdomain>
	<20090204181738.GA16174@elte.hu>
	<1234812741.28801.4.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009 11:32:21 -0800
Ed Swierk <eswierk@aristanetworks.com> wrote:

> Here's another attempt at decoupling the setup of memory-mapped PCI
> configuration space from ACPI.  I implemented your suggestions for
> moving the ACPI-specific code to a separate file.  I left the
> definition of struct acpi_mcfg_allocation alone, and created a new
> struct pci_mcfg_allocation.  The former is now used only for parsing
> the actual ACPI MCFG table, while the latter is used to store
> information about mmcfg regions regardless of where they came from.
> 
> (This is still an RFC; the code is pretty much untested.)
> 

I'm still a bit dubious about this; does it solve a real issue?  Or
just remove the ACPI dependency for its own sake?

-- 
Jesse Barnes, Intel Open Source Technology Center
