Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYFIWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYFIWQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbYFIWQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:16:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:34439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbYFIWQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:16:14 -0400
Date: Mon, 9 Jun 2008 15:14:41 -0700
From: Greg KH <gregkh@suse.de>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080609221440.GA22227@suse.de>
References: <1211735607.14556.14.camel@mtlp.tischlernetz> <20080525181118.GG1791@cs181133002.pp.htv.fi> <1211742202.14556.25.camel@mtlp.tischlernetz> <20080525201807.GK1791@cs181133002.pp.htv.fi> <1211749036.16921.16.camel@mtlp.tischlernetz> <20080525210329.GN1791@cs181133002.pp.htv.fi> <1211752151.16921.25.camel@mtlp.tischlernetz> <1211836606.10718.18.camel@mtlp.tischlernetz> <20080527235619.GI11310@cs181133002.pp.htv.fi> <20080608144112.1d623ed4@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608144112.1d623ed4@mtlp.tischlernetz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 02:41:12PM +0200, Mirco Tischler wrote:
> Here's an update:
> I've contacted the gcc folks. Here is the bugzilla entry:
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=36359
> We were able to trace the error down to usb_submit_urb() in
> drivers/usb/core/urb.c which calls ilog2() and the gcc falsely assumes its
> argument (urb->interval) to be zero. But as I understood they say it's the
> kernel's fault because the code depends on correct optimization what seems a
> little weird for me as incorrect optimization is a gcc bug IMHO. But I am not
> an expert and maybe I've just understood something wrong because I'm not a
> native speaker.

I'm confused how the kernel code could be at fault here.

How could it be fixed to not be at fault?

thanks,

greg k-h
