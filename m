Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbZELXJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbZELXJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbZELXJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:09:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:54688 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbZELXJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:09:39 -0400
Date: Tue, 12 May 2009 16:05:14 -0700
From: Greg KH <gregkh@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>, johannes@sipsolutions.net,
       linuxppc-dev@ozlabs.org, alsa-devel@alsa-project.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] aoa: remove driver_data direct access of
	struct device
Message-ID: <20090512230514.GB11084@suse.de>
References: <4A08828B.7090106@gmail.com> <s5hws8mu8my.wl%tiwai@suse.de> <20090512065743.GA25267@suse.de> <s5hoctyu6m4.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hoctyu6m4.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 09:23:47AM +0200, Takashi Iwai wrote:
> At Mon, 11 May 2009 23:57:43 -0700,
> Greg KH wrote:
> > 
> > On Tue, May 12, 2009 at 08:40:05AM +0200, Takashi Iwai wrote:
> > > At Mon, 11 May 2009 21:54:51 +0200,
> > > Roel Kluin wrote:
> > > > 
> > > > To avoid direct access to the driver_data pointer in struct device, the
> > > > functions dev_get_drvdata() and dev_set_drvdata() should be used.
> > > > 
> > > > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > > 
> > > The same fix has been already in Greg's tree (and thus in linux-next).
> > > 
> > > Greg, is it OK that I take over your patch to sound git tree?
> > 
> > Yes, please do, no objection from me at all.
> 
> OK, will do.
> 
> BTW, should it be pushed to 2.6.30?  If "the near future" you
> mentioned in the patch means 2.6.31, it'll be better to merge that fix
> now.  Otherwise, I'm going to apply the patch as a 2.6.31 material.

.31 is fine, that is what I was meaning by with "near future" :)

thanks,

greg k-h
