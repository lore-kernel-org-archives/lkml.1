Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab0BHWeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:34:37 -0500
Received: from kroah.org ([198.145.64.141]:45722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252Ab0BHWef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:34:35 -0500
Date: Sun, 7 Feb 2010 20:26:34 -0800
From: Greg KH <greg@kroah.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging wlan-ng: fix to allow driver to be built on
	2.6.33-rc6
Message-ID: <20100208042634.GA30314@kroah.com>
References: <1265283229.2175.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265283229.2175.10.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 11:33:49AM +0000, Richard Kennedy wrote:
> Due to the re-factoring of wext in commit
> 3d23e349d807177eaf519d444677cee86b1a04cf
>     
> WIRELESS_EXT must now be selected in Kconfig to allow this driver to be
> built.
>     
> Also remove iw_handle_def private initialisations as they are no longer
> need these.
>     
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> ----
> Hi Greg,
> I hadn't built this driver for a while & just noticed that it doesn't
> built on 2.6.33-rc6.
> Here's a minimal fix to at least get it going.

Oops, i already have a patch in my tree that fixes this, so I just
applid the second part of your patch, as the cleanup is valie.

thanks,

greg k-h
