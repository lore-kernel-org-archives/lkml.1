Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYKKGfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYKKGfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYKKGe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:34:57 -0500
Received: from kroah.org ([198.145.64.141]:37860 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755289AbYKKGe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:34:56 -0500
Date: Mon, 10 Nov 2008 22:15:20 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: only build the tree if we really want to
Message-ID: <20081111061520.GB13156@kroah.com>
References: <20081108054511.GA28846@kroah.com> <1226123143-28859-1-git-send-email-greg@kroah.com> <4915B769.6090403@s5r6.in-berlin.de> <20081108183044.GA16504@suse.de> <4915E91D.8080707@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4915E91D.8080707@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 08, 2008 at 08:31:41PM +0100, Stefan Richter wrote:
> Greg KH wrote:
> > On Sat, Nov 08, 2008 at 04:59:37PM +0100, Stefan Richter wrote:
> >>> -endif # STAGING
> >>> +endif # !STAGING_EXCLUDE_BUILD
> >> Which purpose is the STAGING kconfig variable serving after this?
> > 
> > Sitting there and looking pretty :)
> > 
> >> It controls the visibility of the menu, but switching it off won't
> >> switch off the staging drivers if they were previously enabled, would
> >> it?
> > 
> > Try it and look in wonder :)
> > 
> > If something affects the visibility of the menu for those config
> > options, it controls if those options can be enabled or not.
> 
> Right.  But if you had STAGING on, STAGING_EXCLUDE_BUILD off, and for
> example ET131X on, then ET131X will still be on if you switch STAGING
> off and save the configuration.

I think Linus fixed this, look at 2.6.28-rc4.

thanks,

greg k-h
