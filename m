Return-Path: <linux-kernel-owner+w=401wt.eu-S934787AbXGRXYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787AbXGRXYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757391AbXGRXYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:24:41 -0400
Received: from ns.suse.de ([195.135.220.2]:57232 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXGRXYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:24:40 -0400
Date: Wed, 18 Jul 2007 15:07:39 -0700
From: Greg KH <gregkh@suse.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       chas@cmf.nrl.navy.mil, rolandd@cisco.com, dwmw2@infradead.org
Subject: Re: [git patches 1/2] warnings: attack valid cases spotted by
	warnings
Message-ID: <20070718220739.GA8305@suse.de>
References: <20070717214239.GF28448@devserv.devel.redhat.com> <20070718024637.GC6146@suse.de> <469E71F9.5000005@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469E71F9.5000005@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 04:03:05PM -0400, Jeff Garzik wrote:
>  Greg KH wrote:
> > On Tue, Jul 17, 2007 at 05:42:39PM -0400, Jeff Garzik wrote:
> >> commit ae97fec3701a559929c3529e35417fab133a4d39
> >> Author: Jeff Garzik <jeff@garzik.org>
> >> Date:   Tue Jul 17 01:08:29 2007 -0400
> >>
> >>     drivers/usb/misc/auerswald: fix status check, remove redundant check
> >>         1) We should only set 'actual_length' output variable if usb 
> >> length is
> >>     known to be good.
> >>         2) No need to check actual_length for NULL.  The only caller 
> >> always
> >>     passes non-NULL value.
> >>         Signed-off-by: Jeff Garzik <jeff@garzik.org>
> > I have no objection to this patch at all, however it does not remove the
> > compiler warning :(
> 
>  The description doesn't say it removes a warning, so it doesn't :)
> 
>  You want to look at
> 
>  	drivers/*: mark variables with uninitialized_var()
> 
>  which was in posting "[git patches 2/2] warnings: use uninitialized_var()" 
>  and is now upstream commit a6343afb6e16b65b9f0b264f94f8207212e7e3ae

Ah, sorry, I just went for the first USB change entry, sorry about that
:)

And thanks for doing this, clean builds are good to have.

greg k-h
