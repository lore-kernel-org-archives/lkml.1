Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbZHZVnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbZHZVnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbZHZVnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:43:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57918 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZHZVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:43:41 -0400
Date: Wed, 26 Aug 2009 17:43:53 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH 7/7] PM: Asynchronous suspend and resume of i8042
Message-ID: <20090826154352.GB1338@ucw.cz>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl> <200908170221.34885.rjw@sisk.pl> <1250579010.5351.69.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250579010.5351.69.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-08-18 15:03:30, Zhang Rui wrote:
> On Mon, 2009-08-17 at 08:21 +0800, Rafael J. Wysocki wrote:
> > Set async_suspend for i8042.
> > 
> it's the psmouse reset that takes the 0.4 seconds during suspend.
> ???so we should call device_enable_async_suspend for the psmouse serio
> device in psmouse-base.c

Do we really need to reset it during suspend?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
