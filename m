Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299Ab0AQR7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab0AQR7g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0AQR7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:59:35 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:57089 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754264Ab0AQR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:59:34 -0500
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jan 2010 12:59:34 EST
Date: Sun, 17 Jan 2010 18:53:07 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] staging: iio: Fix locking in __iio_push_event
Message-ID: <20100117175307.GH31478@distanz.ch>
References: <1263547801-8640-1-git-send-email-tklauser@distanz.ch> <20100115175940.GA10981@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100115175940.GA10981@kroah.com>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-01-15 at 18:59:41 +0100, Greg KH <greg@kroah.com> wrote:
> On Fri, Jan 15, 2010 at 10:30:01AM +0100, Tobias Klauser wrote:
> > Correctly unlock the mutex when leaving the function. This was
> > discovered by the stanse tool at
> > http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=33-rc&id=138
> > 
> > Cc: Jiri Slaby <jirislaby@gmail.com>
> > Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> 
> Sorry, but this is already fixed in my tree, someone beat you to it :)

Oh, I seem to have missed that one in linux-next (or I should have a
closer look at your staging repository the next time :-). Never mind...

Cheers, Tobias
