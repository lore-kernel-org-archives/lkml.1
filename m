Return-Path: <linux-kernel-owner+w=401wt.eu-S1757542AbXI1DW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542AbXI1DW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 23:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754788AbXI1DWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 23:22:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42561 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbXI1DWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 23:22:17 -0400
Date: Thu, 27 Sep 2007 20:21:35 -0700
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] fs: Correct SuS compliance for open of large file
	without options
Message-ID: <20070928032135.GA23543@kroah.com>
References: <20070927143548.GT5243@kernel.dk> <20070927154432.302ec5a7@the-village.bc.nu> <20070927150853.GA10154@kernel.dk> <20070927161912.2f08aff6@the-village.bc.nu> <20070927155902.GA6450@thunk.org> <20070927102343.1a113ccc.akpm@linux-foundation.org> <20070927175917.GB8339@kroah.com> <20070927183742.GA23734@thunk.org> <20070927213445.GA7857@kroah.com> <20070927231927.GE8688@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927231927.GE8688@thunk.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 07:19:27PM -0400, Theodore Tso wrote:
> On Thu, Sep 27, 2007 at 02:34:45PM -0700, Greg KH wrote:
> > Ok, how then should I advertise this better?  What can we do better to
> > help userspace programmers out in this regard?
> 
> Would you accept a patch which causes the deprecated sysfs
> files/directories to disappear, even if CONFIG_SYS_DEPRECATED is
> defined, via a boot-time parameter?

As discussed in the kernel summit talk about this very topic, Kay is
working on a patch to do just that :)

> Many people and distros are
> likely to keep CONFIG_SYS_DEPRECATED defined just our of paranoia that
> things might break.  Doing a quick google, I note that Fedora has been
> going back and forth of turning it off, watching things break, and
> then turning it back on.  The latest time, the changelog said:
> 
> * Fri Jan 26 23:00:00 2007 Bill Nottingham <notting{%}redhat{*}com>
> 
>     - turn on CONFIG_SYSFS_DEPRECATED so that things actually work. *sigh*
> 
> (and I've checked, Fedora's CVS still has CONFIG_SYSFS_DEPRECATED
> defined; it's not just Debian at fault here.)

That's odd, SuSE and Gentoo have been working for quite some time just
fine with that option disabled :)

thanks,

greg k-h
