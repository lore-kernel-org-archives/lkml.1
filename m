Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbYKSG2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbYKSG2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYKSG2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:28:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:52083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751069AbYKSG2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:28:09 -0500
Date: Tue, 18 Nov 2008 22:15:58 -0800
From: Greg KH <gregkh@suse.de>
To: Eric Sandall <eric@sandall.us>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.27.6
Message-ID: <20081119061558.GB4332@suse.de>
References: <20081113185350.GA3765@kroah.com> <20081118092051.53d1fcc2@sandall.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081118092051.53d1fcc2@sandall.us>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 09:20:51AM -0800, Eric Sandall wrote:
> On Thu, 13 Nov 2008 10:53:50 -0800
> Greg KH <gregkh@suse.de> wrote:
> > We (the -stable team) are announcing the release of the 2.6.27.6
> > kernel.
> > 
> > It contains a wide range of bugfixes, and all users of the 2.6.27
> > kernel series are strongly encouraged to upgrade.
> > 
> > I'll also be replying to this message with a copy of the patch between
> > 2.6.27.5 and 2.6.27.6
> > Francois Romieu (3):
> >       r8169: get ethtool settings through the generic mii helper
> >       r8169: fix RxMissed register access
> >       r8169: wake up the PHY of the 8168
> 
> My r8169 no longer compiles:
> ...
>   Building modules, stage 2.
>   MODPOST 243 modules
> ERROR: "mii_ethtool_gset" [drivers/net/r8169.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Attached my .config. Also tried witht he following changed, with the
> same results:
> +CONFIG_NET_ETHERNET=y
> +CONFIG_MII=m

Already fixed in 2.6.27.7-rc2.

thanks,

greg k-h
