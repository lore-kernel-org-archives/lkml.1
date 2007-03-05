Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbXCENAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbXCENAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933449AbXCENAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:00:12 -0500
Received: from thunk.org ([69.25.196.29]:51558 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933429AbXCENAJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:00:09 -0500
Date: Mon, 5 Mar 2007 07:59:50 -0500
From: Theodore Tso <tytso@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: Matt Mackall <mpm@selenic.com>, Johannes Berg <johannes@sipsolutions.net>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, yi.zhu@intel.com,
       jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
Message-ID: <20070305125950.GC26781@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
	Matt Mackall <mpm@selenic.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	yi.zhu@intel.com, jketreno@linux.intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>, akpm@osdl.org
References: <20070304220857.GH23311@waste.org> <1173051564.6131.13.camel@johannes.berg> <20070305002550.GI23311@waste.org> <20070305011729.GB7681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305011729.GB7681@kroah.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 05:17:29PM -0800, Greg KH wrote:
> I should not have broken any userspace if CONFIG_SYSFS_DEPRECATED is
> enabled with that patch.  If that is enabled, and that patch still
> causes problems, please let me know.

But we still need to update the help text for CONFIG_SYS_DEPRECATED to
make it clear that its deprecation schedule still needs to be 2009 to
2011 (depending on whether we want to accomodate Debian's glacial
release schedule).  Certainly the 2006 date which is currently there
simply isn't accurate.

						- Ted
