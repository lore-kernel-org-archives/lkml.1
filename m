Return-Path: <linux-kernel-owner+w=401wt.eu-S1757087AbYBGHhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087AbYBGHhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 02:37:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbYBGHhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 02:37:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:37424 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbYBGHhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 02:37:46 -0500
Date: Wed, 6 Feb 2008 23:42:08 -0800
From: Greg KH <gregkh@suse.de>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: partition sysfs OOPS in current GIT
Message-ID: <20080207074208.GA25071@suse.de>
References: <20080207070044.GA4851@suse.de> <20080206.231144.174648341.davem@davemloft.net> <20080207072030.GA24242@suse.de> <20080206.232451.146394908.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206.232451.146394908.davem@davemloft.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2008 at 11:24:51PM -0800, David Miller wrote:
> From: Greg KH <gregkh@suse.de>
> Date: Wed, 6 Feb 2008 23:20:30 -0800
> 
> > It's odd that the original one didn't also do that,
> 
> In the old code it would vector through part_sysfs_ops (look at how it
> works before the changeset), which returns 0 if the attribute lacked a
> ->show method.

Ah, yeah, what a fun hack...  Makes sense though.  The updated patch I
send you should do the same thing, just with an additional function
needed.

thanks,

greg k-h
