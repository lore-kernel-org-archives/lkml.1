Return-Path: <linux-kernel-owner+w=401wt.eu-S1753795AbZGXTSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795AbZGXTSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 15:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751191AbZGXTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 15:18:37 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZGXTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 15:18:37 -0400
Date: Fri, 24 Jul 2009 12:16:33 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Trevor Pace <tr212206@dal.ca>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
Message-ID: <20090724191633.GA28619@kroah.com>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
 <200907241853.17877.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907241853.17877.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 06:53:17PM +0200, Oliver Neukum wrote:
> Am Freitag, 24. Juli 2009 17:48:03 schrieb Trevor Pace:
> > Removed useless return value variables.
> >
> > Signed-off By: Trevor Pace <trevor.pace@dal.ca>
> 
> These changes are a bad idea. They'll bite us in the ass as soon as we
> change locking or need to do more cleanups. The preferred form of
> error handling is
> 
> r = op()
> if (r < 0)
> 	goto error_exit;
> 
> I suggest that you don't apply them.

I agree with you, and will not be applying them.

thanks,

greg k-h
