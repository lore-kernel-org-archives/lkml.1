Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYFJSYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYFJSYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYFJSYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:24:17 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:64448 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYFJSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:24:16 -0400
Date: Tue, 10 Jun 2008 14:24:08 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI: PCI slot detection driver
In-reply-to: <20080604201804.GG379@ldl.fc.hp.com>
X-X-Sender: lenb@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
Cc: jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       kaneshige.kenji@jp.fujitsu.com, Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, pbadari@us.ibm.com, linux-pci@vger.kernel.org,
       pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.1.10.0806101418490.14381@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080604200829.GC379@ldl.fc.hp.com>
 <20080604201804.GG379@ldl.fc.hp.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> +#define ACPI_STA_FUNCTIONING            (0x00000008)

please use the existing define in acpi/actypes.h:
#define ACPI_STA_DEVICE_FUNCTIONING     0x08

I don't notice any breakage WRT ACPI usage here,
I defer to Jesse on the PCI-ness parts.

Acked-by: Len Brown <len.brown@intel.com>

thanks,
-len

