Return-Path: <linux-kernel-owner+w=401wt.eu-S1756340AbYIIQe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340AbYIIQe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYIIQeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:34:50 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13293 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYIIQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:34:49 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Martin Doucha <next_ghost@quick.cz>
Subject: Re: ACPI PnP on Intel MU440EX
Date: Tue, 9 Sep 2008 10:34:46 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, matthieu castet <castet.matthieu@free.fr>,
       next_ghost@quick.cz
References: <48BA9B2C.7060007@quick.cz>
In-Reply-To: <48BA9B2C.7060007@quick.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809091034.46729.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 31 August 2008 07:22:52 am Martin Doucha wrote:
> I have trouble with ACPI PnP on one of my machines (Intel MU440EX 
> motherboard made in '98). ACPI PnP doesn't detect built-in parallel port 
> (PNPBIOS does and the port works because I use it to print regularly). I 
> know that I can turn ACPI PnP off by editing .config or using 
> pnpacpi=off boot parameter. I just want to report this problem before 
> PNPBIOS support is dropped (as written in kernel docs).

Thanks very much for the report.  This sounds like it could be a
PNPACPI issue, which I am very interested in fixing.

Can you please turn on CONFIG_PNP_DEBUG in your .config and collect
the complete dmesg log with and without "pnpacpi=off"?

I do have an "lspnp" that works with PNPACPI here:
  http://kernel.org/pub/linux/kernel/people/helgaas/pnputils-0.1.tar.bz2
but it's not widely used.  The debug information from the config
option above is usually more useful.

Bjorn
