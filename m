Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZEWVxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZEWVxk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZEWVxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:53:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbZEWVxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:53:32 -0400
Date: Sat, 23 May 2009 14:25:50 -0700
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-pm@lists.linux-foundation.org,
       stern@rowland.harvard.edu, akpm@linux-foundation.org, pavel@ucw.cz,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pm: remove bus_type suspend_late()/resume_early() V2
Message-ID: <20090523212550.GA23127@suse.de>
References: <20090521082754.1020.73349.sendpatchset@rx1.opensource.se> <200905232258.27407.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905232258.27407.rjw@sisk.pl>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 23, 2009 at 10:58:26PM +0200, Rafael J. Wysocki wrote:
> On Thursday 21 May 2009, Magnus Damm wrote:
> > From: Magnus Damm <damm@igel.co.jp>
> > 
> > Remove the ->suspend_late() and ->resume_early() callbacks
> > from struct bus_type V2. These callbacks are legacy stuff
> > at this point and since there seem to be no in-tree users
> > we may as well remove them. New users should use dev_pm_ops.
> 
> I'd like to apply this patch as is.
> 
> Greg, is it fine with you?

Yes, please feel free to apply this to your tree:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

or do you want me to take it in mine?  If so, no problem, just let me
know, and resend it.

thanks,

greg k-h
