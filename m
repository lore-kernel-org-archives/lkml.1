Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXGCHQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXGCHQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXGCHPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:15:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:45751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbXGCHPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:15:52 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: trenn@suse.de
Subject: Re: [PATCH 3/3] ACPI autoloading - Create __mod_acpi_device_table symbol for all acpi drivers.
Date: Tue, 3 Jul 2007 03:15:33 -0400
User-Agent: KMail/1.9.5
Cc: Mattia Dongili <malattia@linux.it>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       acpi4asus-user <acpi4asus-user@lists.sourceforge.net>
References: <1182112047.4204.12.camel@noname> <20070620170617.GA3226@inferi.kami.home> <1182361643.28514.708.camel@queen.suse.de>
In-Reply-To: <1182361643.28514.708.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030315.33526.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> BTW: I also saw a laptop (IIRC it was a sony) with asus and sony ACPI
> device.
> When both drivers got loaded things broke.
> A solution was to only let the asus driver get active if the device is
> known. Currently, not sure whether still (I sent a patch a while ago),
> the Asus driver falls back to a default ("M6N"?) configuration. IMO this
> is a bit too dangerous and instead a message like "unsupported ASUS
> model found, please send acpidump to linux-acpi@vger.kernel.org".

This is pretty scary.
Can you drop the acpidump output into a bugzilla?

thanks,
-Len
