Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbZIVKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbZIVKCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755887AbZIVKCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:02:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:37845 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755872AbZIVKCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:02:11 -0400
X-Authenticated: #15509084
X-Provags-ID: V01U2FsdGVkX18XjsJiiOgXAiknqwsHH6EI0J1ZDwdnNRYg7f0m+o
	aRw/cDMSjsQdLR
Message-ID: <4AB8A0A2.3010300@gmx.de>
Date: Tue, 22 Sep 2009 12:02:10 +0200
From: Axel Birndt <towerlexa@gmx.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
       Robert Hancock <hancockr@shaw.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-pci@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Ritz <daniel.ritz@gmx.ch>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/3 pci#linux-next] pccard: configure CLS on attach
References: <4A4EE3E9.7090205@kernel.org> <20090917103131.55eca691@jbarnes-g45> <4AB88C28.8070602@kernel.org>
In-Reply-To: <4AB88C28.8070602@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Tejun Heo schrieb:
> For non hotplug PCI devices, the system firmware usually configures
> CLS correctly.  For pccard devices system firmware can't do it and
> Linux PCI layer doesn't do it either.  Unfortunately this leads to
> poor performance for certain devices (sata_sil).  Unless MWI, which
> requires separate configuration, is to be used, CLS doesn't affect
> correctness, so the configuration should be harmless.
> 
> This patch makes pci_set_cacheline_size() always built and export it
> and make pccard call it during attach.
> 
> Please note that some other PCI hotplug drivers (shpchp and pciehp)
> also configure CLS on hotplug.

Hello Tejun,

i would like to ask, when this patch is usable for normal guy's, like me.
could you tell me in which kernel release or in which bugfix this will
be implemented?

currently i'am using Kubuntu 8.04 with all current released bugfixes and
kernel updates...

thanks and regards

-- 

Regards Axel
