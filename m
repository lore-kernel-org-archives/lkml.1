Return-Path: <linux-kernel-owner+w=401wt.eu-S936289AbXFGErl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936289AbXFGErl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 00:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXFGEre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 00:47:34 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42957 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbXFGErd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 00:47:33 -0400
Date: Wed, 6 Jun 2007 21:19:24 -0700
From: Greg KH <greg@kroah.com>
To: Stuart_Hayes@Dell.com
Cc: akpm@linux-foundation.org, malattia@linux.it, gregkh@suse.de,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel]  [PATCH] bug removing ehci-hcd
Message-ID: <20070607041924.GA8545@kroah.com>
References: <20070529093324.92e571a0.akpm@linux-foundation.org> <DFEF91B22ED07447AB6AA4B237F913F9524D64@ausx3mpc125.aus.amer.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9524D64@ausx3mpc125.aus.amer.dell.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 10:26:10AM -0500, Stuart_Hayes@Dell.com wrote:
> 
> I wasn't actually able to reproduce the bug myself, but I guess it is
> pretty obvious that I shouldn't have called cpufreq_unregister_notifier
> with a spinlock held.  I haven't been doing this long enough to know
> exactly which kernel this patch should be against, so let me know if
> this ins't good.  Thanks!
> 
> 
> This patch (for the 2.6.21.3 kernel plus previously sent cpufreq
> notifier patch) fixes a bug caused by calling
> cpufreq_unregister_notifier (which can sleep) while holding a spinlock.
> 
> Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>

Hm, this doesn't apply to the 2.6.21.3 kernel.

Can you send both patches merged together?

And is the fix already in Linus's tree?

thanks,

greg k-h
