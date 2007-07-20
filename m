Return-Path: <linux-kernel-owner+w=401wt.eu-S933053AbXGTHN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053AbXGTHN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758160AbXGTHNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:13:48 -0400
Received: from ns.suse.de ([195.135.220.2]:42885 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753592AbXGTHNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:13:47 -0400
Date: Fri, 20 Jul 2007 00:10:58 -0700
From: Greg KH <gregkh@suse.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: drivers/base/core.c broken for non-CONFIG_HOTPLUG
Message-ID: <20070720071058.GA26261@suse.de>
References: <20070720070106.GH1678@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720070106.GH1678@pengutronix.de>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 09:01:06AM +0200, Robert Schwebel wrote:
> Kay,
> 
> With commit 60a96a59569bab85571d0089682109bd3324e896, you broke
> drivers/base/core.c for systems which have not enabled CONFIG_HOTPLUG.
> 
> You add and use
> 
> 	extern const char *kobject_actions[];
> 
> but the code in lib/kobject_uevent.c who actually brings in the code is
> only compiled when CONFIG_HOTPLUG is enabled.
> 
> Please send a fix.

Already known and reported, see lkml :)

Kay is at GUADEC right now and will provide a patch in a day or so,
unless I beat him to it...

thanks,

greg k-h
