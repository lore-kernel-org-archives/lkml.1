Return-Path: <linux-kernel-owner+w=401wt.eu-S1764523AbXKTXgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764523AbXKTXgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 18:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758246AbXKTXgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 18:36:17 -0500
Received: from ns2.suse.de ([195.135.220.15]:39472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966AbXKTXgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 18:36:16 -0500
Date: Tue, 20 Nov 2007 15:14:53 -0800
From: Greg KH <gregkh@suse.de>
To: Jan Beulich <jbeulich@novell.com>
Cc: gary.hade@us.ibm.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: Avoid creating P2P prefetch window for expansion ROMs
Message-ID: <20071120231453.GA20462@suse.de>
References: <4742C9D7.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4742C9D7.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 03:49:43AM -0700, Jan Beulich wrote:
> This patch (in its incarnation in our SLE10SP2 tree) is causing resource
> allocation failures on one of my machines.

Does the latest 2.6.23 kernel also cause these same problems?

> The condition for this is that besides ROMs behind a bridge not having
> their base addresses assigned there's no extra space available in the
> non-prefetch window to accommodate the ROMs' space. I therefore think
> the change, while having a good reason, isn't complete so far, as it
> would imply the need for checking whether space in the non-prefetch
> window is sufficient and continuing to force the creation of a
> prefetch window otherwise.

Hm, I'll defer to Gary on this one :)

thanks,

greg k-h
