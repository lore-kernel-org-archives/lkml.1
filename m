Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbZBDB2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbZBDB2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZBDB2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:28:43 -0500
Received: from kroah.org ([198.145.64.141]:47813 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbZBDB2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:28:43 -0500
Date: Tue, 3 Feb 2009 17:03:43 -0800
From: Greg KH <greg@kroah.com>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: PS3: replace bus_id usage
Message-ID: <20090204010343.GB17622@kroah.com>
References: <20090126173019.GA12010@kroah.com> <49824308.6020209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49824308.6020209@am.sony.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 04:00:08PM -0800, Geoff Levand wrote:
> Greg KH wrote:
> > From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > These simple debug statments should be using dev_dbg() instead of
> > accessing bus_id directly (or they should use device_name).
> > 
> > As bus_id is going away, this patch is necessary.
> > 
> > Cc: Geoff Levand <geoffrey.levand@am.sony.com>
> > Cc: Kay Sievers <kay.sievers@vrfy.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > ---
> > 
> > This fixes a built-breakage in linux-next.  I'll be glad to keep this in
> > my tree if you don't want to take it in yours, just let me know.
> > 
> >  arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> This looks OK.  Greg, please merge it through your tree.
> 
> Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>

Thanks, I will do that.

greg k-h
