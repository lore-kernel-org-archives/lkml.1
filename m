Return-Path: <linux-kernel-owner+w=401wt.eu-S966939AbXILLKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966939AbXILLKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764452AbXILLKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:10:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49345 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764443AbXILLKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:10:23 -0400
Message-ID: <46E7C91D.3070001@garzik.org>
Date: Wed, 12 Sep 2007 07:10:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>,
       Michael Wu <flamingice@sourmilk.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] pci: fix unterminated pci_device_id lists
References: <20070912064134.GO7910@outflux.net>
In-Reply-To: <20070912064134.GO7910@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> This patch against 2.6.23-rc6 fixes a couple drivers that do not
> correctly terminate their pci_device_id lists.  This results in garbage
> being spewed into modules.pcimap when the module happens to not have
> 28 NULL bytes following the table, and/or the last PCI ID is actually
> truncated from the table when calculating the modules.alias PCI aliases,
> cause those unfortunate device IDs to not auto-load.
> 
> Signed-off-by: Kees Cook <kees@ubuntu.com>

ACK


