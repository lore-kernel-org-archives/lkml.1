Return-Path: <linux-kernel-owner+w=401wt.eu-S1752253AbXCEXHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbXCEXHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbXCEXHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:07:12 -0500
Received: from Mail.MNSU.EDU ([134.29.1.12]:56903 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXCEXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:07:10 -0500
Message-ID: <45ECA237.5040006@mnsu.edu>
Date: Mon, 05 Mar 2007 17:05:27 -0600
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Theodore Tso <tytso@mit.edu>, Matt Mackall <mpm@selenic.com>,
       Johannes Berg <johannes@sipsolutions.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com> <20070305125950.GC26781@thunk.org> <20070305185813.GA31465@kroah.com>
In-Reply-To: <20070305185813.GA31465@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Mar 05, 2007 at 07:59:50AM -0500, Theodore Tso wrote:
>   
> Ok, how about the following patch.  Is it acceptable to everyone?
>
> thanks,
>
> greg k-h
>
> ---
>  init/Kconfig |   13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> --- gregkh-2.6.orig/init/Kconfig
> +++ gregkh-2.6/init/Kconfig
> @@ -290,8 +290,17 @@ config SYSFS_DEPRECATED
>  	  that belong to a class, back into the /sys/class heirachy, in
>  	  order to support older versions of udev.
>  
> -	  If you are using a distro that was released in 2006 or later,
> -	  it should be safe to say N here.
> +	  If you are using an OpenSuSE, Gentoo, Ubuntu, or Fedora
> +	  release from 2007 or later, it should be safe to say N here.
> +
> +	  If you are using Debian or other distros that are slow to
> +	  update HAL, please say Y here.
> +
> +	  If you have any problems with devices not being found properly
> +	  from userspace programs, and this option is disabled, say Y
> +	  here.
> +
> +	  If you are unsure about this at all, say Y.
>  
>  config RELAY
>  	bool "Kernel->user space relay support (formerly relayfs)"

Since it appears you're trying to offend people with this patch, it 
would seem appropriate to call someone's mother a "bad" name.  This may 
be in the style guide; perhaps I should submit a patch.

-- 
Jeffrey Hundstad
PS: Humor (really!) relax.

