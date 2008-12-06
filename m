Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYLFNNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYLFNNX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 08:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbYLFNNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 08:13:14 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51514 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYLFNNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 08:13:14 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <493A79FE.1050403@s5r6.in-berlin.de>
Date: Sat, 06 Dec 2008 14:11:26 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net,
       Jarod Wilson <jwilson@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: ohci1394: "irq 19: nobody cared" during resume from suspend to
 ram
References: <200812061316.38460.elendil@planet.nl>
In-Reply-To: <200812061316.38460.elendil@planet.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> [<ffffffffa00ee981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
> Disabling IRQ #19
...
> So I naively tried the following patch:
> 
> diff --git a/drivers/firewire/fw-ohci.c b/drivers/firewire/fw-ohci.c

drivers/ieee1394/ohci1394.c and drivers/firewire/fw-ohci.c are different
beasts.  Your dmesg shows the former to be active.  Please check.
-- 
Stefan Richter
-=====-==--- ==-- --==-
http://arcgraph.de/sr/
