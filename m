Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbXFALlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbXFALlP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 07:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758730AbXFALlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 07:41:01 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51478 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758728AbXFALlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 07:41:00 -0400
Message-ID: <466005C6.4050303@garzik.org>
Date: Fri, 01 Jun 2007 07:40:54 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Filippo Carletti <carletti@mobilia.it>
CC: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.4.34 - Add some ahci pci ids
References: <465FE51E.2060705@mobilia.it>
In-Reply-To: <465FE51E.2060705@mobilia.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Filippo Carletti wrote:
> This patch adds support for some chipsets in ahci driver.
> The list comes from a patch for redhat kernel 2.6.9-34.
> I only tested ICH8.
> 
> The original patch contained also this lines (that I omitted):
> +       /* JMicron-specific fixup: make sure we're in AHCI mode */
> +       if (pdev->vendor == 0x197b)
> +               pci_write_config_byte(pdev, 0x41, 0xa1);

NAK.  Don't omit obviously needed lines, if you are going to add JMicron 
PCI IDs.

	Jeff



