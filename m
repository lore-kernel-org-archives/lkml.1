Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbYLFPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbYLFPCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 10:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbYLFPCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 10:02:30 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:38812 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755964AbYLFPC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 10:02:29 -0500
From: Frans Pop <elendil@planet.nl>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch,rfc] usb: restore config before enabling device on resume
Date: Sat, 6 Dec 2008 16:02:23 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
References: <200812020320.31876.rjw@sisk.pl> <200812061020.19546.elendil@planet.nl> <200812061448.31468.rjw@sisk.pl>
In-Reply-To: <200812061448.31468.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061602.26002.elendil@planet.nl>
X-OriginalArrivalTime: 06 Dec 2008 15:02:26.0775 (UTC) FILETIME=[A6E7EE70:01C957B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008, Rafael J. Wysocki wrote:
> In fact, I think you could even move the pci_restore_state(dev) into
> usb_hcd_pci_resume_early() that would be executed with interrupts off
> and drop the pci_set_power_state(dev, PCI_D0); entirely (the
> pci_enable_device(dev); would invoke it anyway).

There is quite a lot going on in the resume function that happens before 
pci_restore_state is called and I'm absolutely not confident with messing 
with that, so I'll leave anything more invasive to the USB maintainers.

Cheers,
FJP
