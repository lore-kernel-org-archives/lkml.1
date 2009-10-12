Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbZJLR6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbZJLR6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933009AbZJLR6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:58:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933007AbZJLR6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:58:45 -0400
Date: Mon, 12 Oct 2009 10:35:51 -0700
From: Greg KH <gregkh@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
 anymore
Message-ID: <20091012173551.GC10557@suse.de>
References: <4AD120F2.3020606@tremplin-utc.net>
 <20091011030029.GA6526@suse.de>
 <200910112135.29384.dmitry.torokhov@gmail.com>
 <4AD31709.4000103@tremplin-utc.net>
 <20091012154846.GB7996@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012154846.GB7996@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 08:48:46AM -0700, Dmitry Torokhov wrote:
> > So at least, unbind should fail as well as bind.
> >
> 
> That would be Greg's domain s it is driver core decision whether to
> allow unbinding platform devices registered with
> platform_driver_probe().

No, I do not see why that should not be allowed.

thanks,

greg k-h
