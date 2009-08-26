Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZHZVoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZHZVoL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZHZVoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:44:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57967 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZHZVoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:44:08 -0400
Date: Wed, 26 Aug 2009 17:44:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zhang Rui <rui.zhang@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, Greg KH <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/7] PM: Asynchronous suspend and resume (updated)
Message-ID: <20090826154420.GD1338@ucw.cz>
References: <200908122218.13975.rjw@sisk.pl> <200908170215.21173.rjw@sisk.pl> <1250579793.5351.79.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250579793.5351.79.camel@rzhang-dt>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi!

> I still think that the child device should inherit its parent's
> async_suspend flag to do the asynchronous resume more efficiently.

I really think this should be opt-in. Even if seemingly simple cases
like usb devices... there's stuff like olpc where you have usb device
and sideband channel....

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
