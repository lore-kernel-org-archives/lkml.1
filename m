Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYFYXHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYFYXHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 19:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYFYXHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 19:07:31 -0400
Received: from outbound-mail-121.bluehost.com ([67.222.38.21]:50292 "HELO
	outbound-mail-121.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752388AbYFYXHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 19:07:30 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [patch 0/5] dev_printk() conversions
Date: Wed, 25 Jun 2008 16:07:01 -0700
User-Agent: KMail/1.9.9
Cc: Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20080613165209.507694130@ldl.fc.hp.com>
In-Reply-To: <20080613165209.507694130@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251607.01904.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 13, 2008 9:52 am Bjorn Helgaas wrote:
> These convert some printks to dev_printks.  They are completely
> independent of each other; I'm just posting them together because
> it probably makes sense to review them together.
>
> It'd be nice if a PCI person looked at pci_request_region().  To
> me, it looks like it prints the wrong BAR number (it prints "bar + 1").

Thanks Bjorn, I applied 2-4 to my linux-next tree.  The x86 bits didn't apply 
for me, probably because my tree is slightly out of date, but those changes 
can come through Ingo & co.

Jesse
