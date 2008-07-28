Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYG1HIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYG1HIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 03:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYG1HIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 03:08:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYG1HIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 03:08:38 -0400
Date: Mon, 28 Jul 2008 03:08:27 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB updates
In-Reply-To: <20080727204256.bba5eaf6.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
References: <20080727224104.78b8298d@gaivota> <20080727204256.bba5eaf6.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> I'd really like to get this patch that I mailed to you 2008-July-21 merged...

Your patch looks OK to me. However, this function were moved to 
v4l2-dev.c, by the V4L core changes (the changes broke videodev into two 
different files, and did some improvements there).

Do you mind to rebase your patch?

>
> ---
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add kernel-doc for parameter @index:
>
> Warning(linhead//drivers/media/video/videodev.c:2090): No description found for parameter 'index'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> drivers/media/video/videodev.c |    2 ++
> 1 file changed, 2 insertions(+)
>
> --- linhead.orig/drivers/media/video/videodev.c
> +++ linhead/drivers/media/video/videodev.c
> @@ -2066,6 +2066,8 @@ EXPORT_SYMBOL(video_register_device);
>  *	@type: type of device to register
>  *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
>  *             -1 == first free)
> + *	@index: stream number based on parent device;
> + *		-1 if auto assign, requested number otherwise
>  *
>  *	The registration code assigns minor numbers based on the type
>  *	requested. -ENFILE is returned in all the device slots for this
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org
