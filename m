Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab0AOSEz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757922Ab0AOSEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:04:53 -0500
Received: from kroah.org ([198.145.64.141]:36447 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757924Ab0AOSEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:04:51 -0500
Date: Fri, 15 Jan 2010 09:59:41 -0800
From: Greg KH <greg@kroah.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] staging: iio: Fix locking in __iio_push_event
Message-ID: <20100115175940.GA10981@kroah.com>
References: <1263547801-8640-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263547801-8640-1-git-send-email-tklauser@distanz.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 10:30:01AM +0100, Tobias Klauser wrote:
> Correctly unlock the mutex when leaving the function. This was
> discovered by the stanse tool at
> http://decibel.fi.muni.cz/~xslaby/stanse/error.cgi?db=33-rc&id=138
> 
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Sorry, but this is already fixed in my tree, someone beat you to it :)

thanks,

greg k-h
