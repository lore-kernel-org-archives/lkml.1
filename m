Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbXJIX3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbXJIX3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXJIX3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:29:15 -0400
Received: from mail.suse.de ([195.135.220.2]:36367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138AbXJIX3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:29:14 -0400
Date: Tue, 9 Oct 2007 16:17:14 -0700
From: Greg KH <gregkh@suse.de>
To: Bernardo Innocenti <bernie@codewiz.org>
Cc: Richard Smith <richard@laptop.org>, Andres Salomon <dilinger@laptop.org>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Francesco Sacchi <batt@develer.com>
Subject: Re: [PATCH] ftdi_sio: fix FT232RL support for TIOCMGET
Message-ID: <20071009231714.GG21852@suse.de>
References: <1191654445-17135-1-git-send-email-bernie@codewiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1191654445-17135-1-git-send-email-bernie@codewiz.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2007 at 03:07:25AM -0400, Bernardo Innocenti wrote:
> From: Francesco Sacchi <batt@develer.com>
> 
> Reading serial port status lines was broken on the FT232RL since when it
> has been detected as a separate chip (2.6.22+).  Previously, it would work
> because it was just handled as an FT232BM.
> 
> Additionally, we were also forgetting to remove the dev_attr_latency_timer
> sysfs file in the FT232RL case.
> 
> Note by Bernardo Innocenti: the ftdi_sio maintainer appears to have stepped
> down, so I'm sending this to Greg Kroah-Hartman as the generic USB serial
> maintainer.  Please, let me know if this is not appropriate.
> 
> Signed-Off-By: Francesco Sacchi <batt@develer.com>
> Signed-Off-By: Bernardo Innocenti <bernie@codewiz.org>

This is already queued up for inclusion in the 2.6.24 kernel tree, so
you don't have to resend it.

thanks,

greg k-h
