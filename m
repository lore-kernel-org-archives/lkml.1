Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYHSKwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYHSKwV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 06:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHSKwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 06:52:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57239 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYHSKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 06:52:12 -0400
Date: Tue, 19 Aug 2008 11:29:57 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI PM: Introduce function pci_wake_from_d3 (rev. 2)
Message-ID: <20080819092957.GA26837@elf.ucw.cz>
References: <200808182057.22501.rjw@sisk.pl> <200808182138.00989.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808182138.00989.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [Sorry, it is more useful to define the function so that it takes a second
> argument indicating whether to enable or disable wake-up.]
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> PCI PM: Introduce function pci_wake_from_d3 (rev. 2)
> 
> Many device drivers use the following sequence of statements to
> enable the device to wake up the system while being in the D3_hot
> or D3_cold low power state:
> 
> 	pci_enable_wake(pdev, PCI_D3hot, 1);
> 	pci_enable_wake(pdev, PCI_D3cold, 1);
> 
> However, the second call is not necessary if the first one succeeds
> (the ordering of the statements above doesn't matter here) and it
> may even be harmful, because we are not supposed to enable PME#
> after the wake-up power has been enabled for the device.
> 
> To allow drivers to overcome this problem, introduce function
> pci_wake_from_d3() that will enable the device to wake up the system
> from any of D3_hot and D3_cold as long as the wake-up from at least
> one of them is supported.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.
									Pavel
 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
