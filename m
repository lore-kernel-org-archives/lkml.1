Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbZJNTQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbZJNTQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932156AbZJNTQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:16:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:50625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932433AbZJNTQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:16:34 -0400
Date: Wed, 14 Oct 2009 12:11:59 -0700
From: Greg KH <gregkh@suse.de>
To: Andrey Rahmatullin <wrar@altlinux.org>
Cc: linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: drivers/staging/rt2860 doesn't compile
Message-ID: <20091014191159.GB4874@suse.de>
References: <20091014063824.GD6298@wrars-comp.wrarsdomain>
 <20091014182729.GC19095@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014182729.GC19095@wrars-comp.wrarsdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 12:27:29AM +0600, Andrey Rahmatullin wrote:
> Even after trivial fix (including <linux/sched.h> into
> drivers/staging/rt2860/rt_linux.h) the driver doesn't compile:
> 
> drivers/staging/rt2860/rt_main_dev.c: In function 'rt_ieee80211_if_setup':
> drivers/staging/rt2860/rt_main_dev.c:691: error: 'struct net_device' has
> no member named 'wireless_handlers'

This is already fixed in my tree.

thanks,

greg k-h
