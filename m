Return-Path: <linux-kernel-owner+w=401wt.eu-S1753871Ab0A3QBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab0A3QBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 11:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752889Ab0A3QBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 11:01:43 -0500
Received: from cantor.suse.de ([195.135.220.2]:58933 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628Ab0A3QBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 11:01:43 -0500
Date: Sat, 30 Jan 2010 07:58:57 -0800
From: Greg KH <gregkh@suse.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: tglx@linutronix.de, stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -stable 2.6.32.7] clocksource: fix compilation if no
	GENERIC_TIME
Message-ID: <20100130155857.GA24949@suse.de>
References: <1264866973-9474-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1264866973-9474-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 30, 2010 at 05:56:13PM +0200, Aaro Koskinen wrote:
> Commit a9238ce3bb0fda6e760780b702c6cbd3793087d3 broke compilation on
> platforms that do not implement GENERIC_TIME (e.g. iop32x):
> 
>   kernel/time/clocksource.c: In function 'clocksource_register':
>   kernel/time/clocksource.c:556: error: implicit declaration of function 'clocksource_max_deferment'
> 
> Provide a dummy implementation of clocksource_max_deferment() for such
> platforms.
> 
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> ---

If you want a patch to go into the -stable tree, then add the
	Cc: stable <stable@kernel.org>
line to the signed-off-by area, so that the tools will pick it up
automatically.

thanks,

greg k-h
