Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZA2T1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZA2T1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 14:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbZA2T1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 14:27:45 -0500
Received: from kroah.org ([198.145.64.141]:52891 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbZA2T1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 14:27:44 -0500
Date: Thu, 29 Jan 2009 11:24:23 -0800
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w35und: fix usb_control_msg() error handling in
	wb35_probe()
Message-ID: <20090129192423.GC31847@kroah.com>
References: <Pine.LNX.4.64.0901221205400.27341@melkki.cs.Helsinki.FI> <20090126175115.GA29205@kroah.com> <497DFB04.1040802@cs.helsinki.fi> <84144f020901261010h67958566lbd9ea240dc6d9ec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020901261010h67958566lbd9ea240dc6d9ec@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 08:10:42PM +0200, Pekka Enberg wrote:
> On Mon, Jan 26, 2009 at 8:03 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> > Greg KH wrote:
> >>
> >> On Thu, Jan 22, 2009 at 12:06:33PM +0200, Pekka J Enberg wrote:
> >>>
> >>> From: Pekka Enberg <penberg@cs.helsinki.fi>
> >>>
> >>> If successful, the usb_control_msg() function returns the number of
> >>> bytes transferred. Fix up wb35_probe() to only bail out if the function
> >>> returns a negative number.
> >>>
> >>> Reported-by: Sandro Bonazzola <sandro.bonazzola@gmail.com>
> >>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> >>
> >> I'm confused, should I apply this patch or not?
> >
> > Yes, you should. What's confusing you here?
> 
> Oh, looking at the thread, I see how you got confused. The patch
> doesn't fix all of Sandro's problems but is an obvious improvement so
> it should be merged.

Hm, it doesn't apply to the latest -next tree, care to respin it?

thanks,

greg k-h
