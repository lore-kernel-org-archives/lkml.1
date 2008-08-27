Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYH0QFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYH0QFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbYH0QFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:05:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56713 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757079AbYH0QFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:05:02 -0400
Date: Wed, 27 Aug 2008 09:02:15 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Marcel Janssen <korgull@home.nl>, Felipe Balbi <me@felipebalbi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827160215.GA31458@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808271056.37159.oliver@neukum.org> <20080827152848.GA19710@kroah.com> <200808271744.27967.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808271744.27967.oliver@neukum.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 05:44:26PM +0200, Oliver Neukum wrote:
> Am Mittwoch 27 August 2008 17:28:48 schrieb Greg KH:
> > On Wed, Aug 27, 2008 at 10:56:36AM +0200, Oliver Neukum wrote:
> 
> > So?  What difference does this really matter at normal USB speeds?
> 
> It doesn't matter in terms of speed for you, but it's nice to be nice
> to the rest of the system.

Sure, it's not a real big deal, if this driver doesn't use the
kmalloc-4096 slab cache, someone else will :)

I'll go change it.

thanks,

greg k-h
