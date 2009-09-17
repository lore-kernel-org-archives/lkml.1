Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZIQLlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZIQLlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 07:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZIQLlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 07:41:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:36284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZIQLlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 07:41:13 -0400
Date: Thu, 17 Sep 2009 04:38:53 -0700
From: Greg KH <greg@kroah.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 44/45] PCI: Unhide the SMBus on the Compaq Evo
	D510 USDT
Message-ID: <20090917113853.GA3061@kroah.com>
References: <20090916223613.597295240@mini.kroah.org> <20090916223719.861500408@mini.kroah.org> <20090917095823.12682531@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917095823.12682531@hyperion.delvare>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 09:58:23AM +0200, Jean Delvare wrote:
> Hi Greg,
> 
> On Wed, 16 Sep 2009 15:36:57 -0700, Greg KH wrote:
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Jean Delvare <khali@linux-fr.org>
> > 
> > commit 6b5096e4d4496e185cd1ada5d1b8e1d941c805ed upstream.
> > 
> > One more form factor for Compaq Evo D510, which needs the same quirk
> > as the other form factors. Apparently there's no hardware monitoring
> > chip on that one, but SPD EEPROMs, so it's still worth unhiding the
> > SMBus.
> 
> FWIW, this one doesn't strike me as being needed in -stable. While it
> should be safe (otherwise it wouldn't have gone upstream in the first
> place), it hardly fulfills -stable's requirement that "it must fix a
> real bug that bothers people". There's no hardware monitoring chip on
> the SMBus on this machine, and people can easily live without detailed
> memory module information.
> 
> So it's up to you, but I won't cry if you drop this patch from -stable.

Heh, you were the one that originally cc:ed the patch to
stable@kernel.org, so I figured you wanted it in.

Quirks like this are simple to add, I have no problem taking it, so
might as well leave it.

thanks,

greg k-h
