Return-Path: <linux-kernel-owner+w=401wt.eu-S1754986AbZJ0Wc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986AbZJ0Wc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZJ0Wc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:32:59 -0400
Received: from kroah.org ([198.145.64.141]:55114 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950AbZJ0Wc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:32:57 -0400
Date: Tue, 27 Oct 2009 15:12:19 -0700
From: Greg KH <greg@kroah.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: Staging: netwave: move driver to staging
Message-ID: <20091027221219.GB20746@kroah.com>
References: <1256015830-12700-4-git-send-email-linville@tuxdriver.com>
 <20091027203643.GA28719@kroah.com>
 <20091027210554.GG15566@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027210554.GG15566@tuxdriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 05:05:54PM -0400, John W. Linville wrote:
> On Tue, Oct 27, 2009 at 01:36:43PM -0700, Greg KH wrote:
> > On Tue, Oct 20, 2009 at 02:17:10PM +0900, John W. Linville wrote:
> > > -menuconfig WLAN_80211
> > 
> > If you are removing this config option, what should we use to depend on
> > the wireless stack?  This is what the staging wireless drivers use,
> > should they be changed to use something else?
> 
> Hmmm...probably WLAN will do.  I should probably make that depend on NETDEVICES as well...

Ok, I'll go change the staging drivers now to depend on that so they
don't "disappear" when this change goes through your tree.

thanks,

greg k-h
