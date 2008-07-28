Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbYG1PTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbYG1PTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYG1PTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:19:42 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45522 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbYG1PTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:19:41 -0400
Date: Mon, 28 Jul 2008 08:18:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB updates
Message-Id: <20080728081813.423ac50c.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
References: <20080727224104.78b8298d@gaivota>
	<20080727204256.bba5eaf6.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 03:08:27 -0400 (EDT) Mauro Carvalho Chehab wrote:

> Hi Randy,
> 
> > I'd really like to get this patch that I mailed to you 2008-July-21 merged...
> 
> Your patch looks OK to me. However, this function were moved to 
> v4l2-dev.c, by the V4L core changes (the changes broke videodev into two 
> different files, and did some improvements there).
> 
> Do you mind to rebase your patch?

What tree contains v4l2-dev.c?
It's not in today's linux-next.  Shouldn't it be, or is it for after 2.6.27?


> >
> > ---
> >
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> >
> > Add kernel-doc for parameter @index:
> >
> > Warning(linhead//drivers/media/video/videodev.c:2090): No description found for parameter 'index'
> >
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> > drivers/media/video/videodev.c |    2 ++
> > 1 file changed, 2 insertions(+)
> >
> > --- linhead.orig/drivers/media/video/videodev.c
> > +++ linhead/drivers/media/video/videodev.c
> > @@ -2066,6 +2066,8 @@ EXPORT_SYMBOL(video_register_device);
> >  *	@type: type of device to register
> >  *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
> >  *             -1 == first free)
> > + *	@index: stream number based on parent device;
> > + *		-1 if auto assign, requested number otherwise
> >  *
> >  *	The registration code assigns minor numbers based on the type
> >  *	requested. -ENFILE is returned in all the device slots for this


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
