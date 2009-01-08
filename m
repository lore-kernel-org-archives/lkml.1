Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbZAIFGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbZAIFGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbZAIFFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:05:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:57679 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095AbZAIFFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:05:49 -0500
Date: Thu, 8 Jan 2009 08:30:24 -0800
From: Greg KH <gregkh@suse.de>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       ben-linux@fluff.org
Subject: Re: [PATCH 1/3] Driver for user access to internal clocks
Message-ID: <20090108163024.GB26413@suse.de>
References: <8447d6730901080149l4146139an9fad00fd88d72fb9@mail.gmail.com> <20090108112741.GA3053@local> <8447d6730901080806r238354c7u81071a28d8b483ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730901080806r238354c7u81071a28d8b483ff@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 05:06:58PM +0100, Davide Rizzo wrote:
> > Davide,
> > please don't put this in the drivers/uio/ directory. This is no UIO driver.
> >
> > Thanks,
> > Hans
> >
> Ok, moved to /drivers/misc
> 
> This driver is for user level programs to interact with system clocks.

Same comments here as for your "timer.c" file:
	- too generic of a name
	- needs proper documentation
	- send any kernel api changes also to linux-api@vger.kernel.org

thanks,

greg k-h
