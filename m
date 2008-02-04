Return-Path: <linux-kernel-owner+w=401wt.eu-S1756689AbYBDSb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689AbYBDSb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 13:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbYBDSbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 13:31:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47338 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbYBDSbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 13:31:19 -0500
Date: Mon, 4 Feb 2008 10:27:49 -0800
From: Greg KH <greg@kroah.com>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Basic braille screen reader support
Message-ID: <20080204182749.GA22999@kroah.com>
References: <20080204031842.GE4439@implementation> <20080204171008.GA22050@kroah.com> <20080204172441.GP5205@implementation.uk.xensource.com> <20080204180617.GA22656@kroah.com> <20080204181512.GR5205@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204181512.GR5205@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 06:15:12PM +0000, Samuel Thibault wrote:
> Greg KH, le Mon 04 Feb 2008 10:06:17 -0800, a ?crit :
> > > However, they share the same low-level primitives: the recently added
> > > keyboard and vc notifiers, screen_glyph(), inverse_translate(),
> > > kd_mksound, etc.
> > 
> > I guess I'm worried that the hooks that you add here will not be usable
> > by speakup, and we'll have to add more in places close to this, but not
> > quite the same.
> 
> Actually, speakup already just use these and no others.

Great.  I have no objection to this patch then :)

thanks,

greg k-h
