Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752561AbYLQVAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbYLQVAb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbYLQVAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:00:22 -0500
Received: from kroah.org ([198.145.64.141]:40581 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbYLQVAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:00:21 -0500
Date: Wed, 17 Dec 2008 12:52:49 -0800
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
Message-ID: <20081217205249.GA25893@kroah.com>
References: <200812082156.26522.hverkuil@xs4all.nl> <200812172039.03436.hverkuil@xs4all.nl> <20081217195329.GB25211@kroah.com> <200812172118.29574.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812172118.29574.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 09:18:29PM +0100, Hans Verkuil wrote:
> On Wednesday 17 December 2008 20:53:29 Greg KH wrote:
> > So why is V4L different than the rest of the kernel in that it wishes to
> > do things differently?
> 
> Because it has almost no proper framework to speak of and what little there 
> is has been pretty much unchanged since the very beginning.

Ick.

> I'm trying to develop a decent framework that should help support upcoming 
> devices and generally make life easier for v4l driver developers.
> 
> And I've no idea why we don't just use the device's release() callback for 
> this. I'm going to implement this right now :-)

Thanks, that makes oh so much more sense.  Let me know when you've
completed it so I can make your cdev change as well.

thanks,

greg k-h
