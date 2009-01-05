Return-Path: <linux-kernel-owner+w=401wt.eu-S1753848AbZAEKvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbZAEKvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 05:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZAEKvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 05:51:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40899 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZAEKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 05:51:08 -0500
Date: Mon, 5 Jan 2009 11:51:05 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/10] PCI PM: Power-manage devices without drivers during suspend-resume
Message-ID: <20090105105105.GF27199@atrey.karlin.mff.cuni.cz>
References: <200812190049.34343.rjw@sisk.pl> <200812281607.28007.rjw@sisk.pl> <200812302333.45560.rjw@sisk.pl> <200812302338.42915.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812302338.42915.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> PCI devices without drivers can be put into low power states during
> suspend with the help of pci_prepare_to_sleep() and prevented from
> generating wake-up events during resume with the help of
> pci_enable_wake().  However, it's better not to put bridges into
> low power states during suspend, because that might result in entire
> bus segments being powered off.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <Pavel@suse.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
