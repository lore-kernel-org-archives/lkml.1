Return-Path: <linux-kernel-owner+w=401wt.eu-S1765540AbXKOR7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765540AbXKOR7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:59:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764371AbXKOR6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:58:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:33703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764195AbXKOR6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:58:49 -0500
Date: Thu, 15 Nov 2007 09:58:10 -0800
From: Greg KH <gregkh@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dave Young <hidave.darkstar@gmail.com>, Greg KH <greg@kroah.com>
Subject: Re: [patch 04/13] param_sysfs_builtin memchr argument fix
Message-ID: <20071115175810.GC24531@suse.de>
References: <20071115042610.731859958@mini.kroah.org> <20071115060927.GE7602@kroah.com> <473C6FCF.6010501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473C6FCF.6010501@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 11:11:59AM -0500, Chuck Ebbert wrote:
> On 11/15/2007 01:09 AM, Greg KH wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Dave Young <hidave.darkstar@gmail.com>
> > 
> > patch faf8c714f4508207a9c81cc94dafc76ed6680b44 in mainline.
> > 
> > If memchr argument is longer than strlen(kp->name), there will be some
> > weird result.
> > 
> > It will casuse duplicate filenames in sysfs for the "nousb".  kernel
> > warning messages are as bellow:
> > 
> 
> Needs an additional fix:
> 
> Commit:     22800a2830ec07e7cc5c837999890ac47cc7f5de
> fix param_sysfs_builtin name length check

That just went in yesterday, right?  If so, it will have to wait until
the next -stable review cycle, unless it's totally broken without that
change.

Is it?

thanks,

greg k-h
