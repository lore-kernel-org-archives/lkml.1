Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYFJVSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYFJVSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbYFJVSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:18:14 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:34990 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbYFJVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:18:12 -0400
Date: Tue, 10 Jun 2008 15:17:00 -0600
From: Alex Chiang <achiang@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kaneshige.kenji@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: PCI slot detection driver
Message-ID: <20080610211700.GH25295@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, Len Brown <lenb@kernel.org>,
	jbarnes@virtuousgeek.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	kaneshige.kenji@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, greg@kroah.com, pbadari@us.ibm.com,
	linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <20080604201804.GG379@ldl.fc.hp.com> <alpine.LFD.1.10.0806101418490.14381@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806101418490.14381@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Len Brown <lenb@kernel.org>:
> 
> 
> > +#define ACPI_STA_FUNCTIONING            (0x00000008)
> 
> please use the existing define in acpi/actypes.h:
> #define ACPI_STA_DEVICE_FUNCTIONING     0x08

Ok, updated.

> I don't notice any breakage WRT ACPI usage here,
> I defer to Jesse on the PCI-ness parts.
> 
> Acked-by: Len Brown <len.brown@intel.com>

Thanks!

/ac

