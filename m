Return-Path: <linux-kernel-owner+w=401wt.eu-S1760841AbYFJKQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841AbYFJKQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 06:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbYFJKQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 06:16:03 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:38390 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbYFJKQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 06:16:01 -0400
Date: Tue, 10 Jun 2008 13:15:04 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Greg KH <gregkh@suse.de>
Cc: Mirco Tischler <mt-ml@gmx.de>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG: 2.6.26-rc3] ERROR: "____ilog2_NaN" undefined
Message-ID: <20080610101504.GA17556@cs181133002.pp.htv.fi>
References: <20080525181118.GG1791@cs181133002.pp.htv.fi> <1211742202.14556.25.camel@mtlp.tischlernetz> <20080525201807.GK1791@cs181133002.pp.htv.fi> <1211749036.16921.16.camel@mtlp.tischlernetz> <20080525210329.GN1791@cs181133002.pp.htv.fi> <1211752151.16921.25.camel@mtlp.tischlernetz> <1211836606.10718.18.camel@mtlp.tischlernetz> <20080527235619.GI11310@cs181133002.pp.htv.fi> <20080608144112.1d623ed4@mtlp.tischlernetz> <20080609221440.GA22227@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080609221440.GA22227@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 03:14:41PM -0700, Greg KH wrote:
> On Sun, Jun 08, 2008 at 02:41:12PM +0200, Mirco Tischler wrote:
> > Here's an update:
> > I've contacted the gcc folks. Here is the bugzilla entry:
> > http://gcc.gnu.org/bugzilla/show_bug.cgi?id=36359
> > We were able to trace the error down to usb_submit_urb() in
> > drivers/usb/core/urb.c which calls ilog2() and the gcc falsely assumes its
> > argument (urb->interval) to be zero. But as I understood they say it's the
> > kernel's fault because the code depends on correct optimization what seems a
> > little weird for me as incorrect optimization is a gcc bug IMHO. But I am not
> > an expert and maybe I've just understood something wrong because I'm not a
> > native speaker.
> 
> I'm confused how the kernel code could be at fault here.
> 
> How could it be fixed to not be at fault?

I'm quite sure this is (or was) a bug in gcc.

I'll update the gcc bug.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

