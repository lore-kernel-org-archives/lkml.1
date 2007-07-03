Return-Path: <linux-kernel-owner+w=401wt.eu-S1757748AbXGCHMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748AbXGCHMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbXGCHLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:11:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:35006 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXGCHLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:11:51 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table symbol for all acpi drivers.
Date: Tue, 3 Jul 2007 03:11:35 -0400
User-Agent: KMail/1.9.5
Cc: Thomas Renninger <trenn@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Kay Sievers <kasievers@suse.de>
References: <1182111863.4204.6.camel@noname> <1182257607.28514.643.camel@queen.suse.de> <20070619212757.GB23946@khazad-dum.debian.net>
In-Reply-To: <20070619212757.GB23946@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030311.36139.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My $0.02 on thinkpad_acpi & HID's...

1. moving to DMI binding from PNP-id binding
sounds like a step in the wrong direction.

Are there thinkpads that you need to support that don't export IBM0068?

There is a long tradition of DMI information being copy/pasted
and being invalid.  While the thinkpad BIOS guys are probably
above average here, they're probably not immune from this issue.

At the end of the day, I'd be astonished if somebody told me that
the Windows thinkpad platform driver binds via DMI strings instead
of binding to IBM0068 -- which was likely invented for this sole purpose.

2. IBM_PCI_HID = ACPI_PCI_HOST_HID = PCI_ROOT_HID_STRING = "PNP0A03"

There is nothing IBM specific about a PCI root bridge.
If you need to use this one, please call it PCI_ROOT_HID_STRING.

thanks,
-Len
