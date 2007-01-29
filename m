Return-Path: <linux-kernel-owner+w=401wt.eu-S1751604AbXA2Plo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbXA2Plo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXA2Plo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:41:44 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37625 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751604AbXA2Plo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:41:44 -0500
Date: Mon, 29 Jan 2007 15:51:25 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Jean Delvare <jdelvare@suse.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Daniel Drake <dsd@reactivated.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: via irq quirk breakage
Message-ID: <20070129155125.74758322@localhost.localdomain>
In-Reply-To: <200701291600.32580.jdelvare@suse.de>
References: <45B6A94A.3010006@yahoo.com.au>
	<200701291600.32580.jdelvare@suse.de>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix VIA quirks that were recently broken by Alan Cox in the upstream
> kernel (commit 1597cacbe39802d86656d1f2e6329895bd2ef531).
> 
> My understanding is that pci_find_present() doesn't work yet at the
> time the quirks are run. So I used a two-step quirk as is done for
> some other quirks already. First we detect the VIA south bridges
> and set the right low and high device limits, then we are ready to
> actually run the quirks on the affected devices.

My PCI tree is somewhat different to the default one and I did test it
but possibly sucked in some dependancies on the cyrix and other early PCI
handling changes in my dev tree. 

> Signed-off-by: Jean Delvare <jdelvare@suse.de>

Acked-by: Alan Cox <alan@redhat.com>

This is a lot neater than the original patch too. Only problem I see is
pci=reverse might need more care.

Alan
