Return-Path: <linux-kernel-owner+w=401wt.eu-S1758332AbZFPTSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758332AbZFPTSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753212AbZFPTS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:18:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:39546 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbZFPTS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:18:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,231,1243839600"; 
   d="scan'208";a="155271962"
Date: Tue, 16 Jun 2009 12:18:28 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andreas Mohr <andim2@users.sourceforge.net>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PCI PM: Fix handling of devices without PM support by
 pci_target_state()
Message-ID: <20090616121828.2a7a8677@jbarnes-g45>
In-Reply-To: <200906142125.03418.rjw@sisk.pl>
References: <200906142125.03418.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009 21:25:02 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If a PCI device is not power-manageable either by the platform, or
> with the help of the native PCI PM interface, pci_target_state() will
> return either PCI_D3hot, or PCI_POWER_ERROR for it, depending on
> whether or not the device is configured to wake up the system.  Alas,
> none of these return values is correct, because each of them causes
> pci_prepare_to_sleep() to return error code, although it should
> complete successfully in such a case.
> 
> Fix this problem by making pci_target_state() always return PCI_D0
> for devices that cannot be power managed.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> Hi Jesse,
> 
> I think this is 2.6.31 material, probably -stable too.

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
