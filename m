Return-Path: <linux-kernel-owner+w=401wt.eu-S932478AbXDWXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932478AbXDWXi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932564AbXDWXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:38:57 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33534 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932478AbXDWXi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:38:56 -0400
Message-ID: <462D438D.7060909@garzik.org>
Date: Mon, 23 Apr 2007 19:38:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Karsten Vieth <k.vieth@gmx.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SATA SB600 works in 2.6.20.4 but not in 2.6.21-rc5 with irqpoll
 parameter
References: <462D27AF.90403@gmx.com>
In-Reply-To: <462D27AF.90403@gmx.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Vieth wrote:
> I can't report this problem from a new kernel, but i have the same
> problem with the kernel 2.6.20.1-33x from f7-test3.
> 
> I managed to boot with these options:
> linux noapic acpi=off pci=nomsi irqpoll

Can you narrow down the options?

Hopefully pci=nomsi or similar should do it.

irqpoll in particular is heavyweight and to be avoided if possible.

	Jeff



