Return-Path: <linux-kernel-owner+w=401wt.eu-S932884AbZHVJYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884AbZHVJYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 05:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbZHVJYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 05:24:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43025 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbZHVJYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 05:24:35 -0400
Date: Sat, 22 Aug 2009 11:24:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 1/3] PM: Asynchronous resume of devices
Message-ID: <20090822092429.GC11448@elf.ucw.cz>
References: <200908122218.13975.rjw@sisk.pl> <200908122220.03363.rjw@sisk.pl> <20090814163328.GF1626@ucw.cz> <200908152259.18417.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908152259.18417.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Do we really need async for noirq handlers?
> 
> Yes, we do.  Specifically, for PCI.

Do noirq parts of PCI handling really so long that we need to make
them async?

Async in normal paths looks pretty much okay to me, but in noirq
parts, locking is tricky, etc...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
