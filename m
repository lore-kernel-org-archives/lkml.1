Return-Path: <linux-kernel-owner+w=401wt.eu-S1756439AbZELHDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbZELHDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbZELHDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:03:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:60173 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZELHDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:03:25 -0400
Date: Mon, 11 May 2009 23:57:43 -0700
From: Greg KH <gregkh@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Roel Kluin <roel.kluin@gmail.com>, johannes@sipsolutions.net,
       linuxppc-dev@ozlabs.org, alsa-devel@alsa-project.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] aoa: remove driver_data direct access of
	struct device
Message-ID: <20090512065743.GA25267@suse.de>
References: <4A08828B.7090106@gmail.com> <s5hws8mu8my.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hws8mu8my.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 12, 2009 at 08:40:05AM +0200, Takashi Iwai wrote:
> At Mon, 11 May 2009 21:54:51 +0200,
> Roel Kluin wrote:
> > 
> > To avoid direct access to the driver_data pointer in struct device, the
> > functions dev_get_drvdata() and dev_set_drvdata() should be used.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> 
> The same fix has been already in Greg's tree (and thus in linux-next).
> 
> Greg, is it OK that I take over your patch to sound git tree?

Yes, please do, no objection from me at all.

thanks,

greg k-h
