Return-Path: <linux-kernel-owner+w=401wt.eu-S1763988AbZE1UYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763988AbZE1UYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZE1UYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:24:25 -0400
Received: from kroah.org ([198.145.64.141]:58285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZE1UYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:24:24 -0400
Date: Thu, 28 May 2009 13:14:50 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core : fix request_firmware_nowait
Message-ID: <20090528201450.GA4043@kroah.com>
References: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com> <20090522161016.36ef6f15@lxorguk.ukuu.org.uk> <d82e647a0905220826p378f6bb4vac9150343b5c3622@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d82e647a0905220826p378f6bb4vac9150343b5c3622@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 22, 2009 at 11:26:16PM +0800, Ming Lei wrote:
> 2009/5/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > On Fri, 22 May 2009 23:06:27 +0800
> > tom.leiming@gmail.com wrote:
> >
> >> From: Ming Lei <tom.leiming@gmail.com>
> >>
> >> request_firmware_nowait declares it can be called in non-sleep contexts,
> >> but kthead_run which is called by request_firmware_nowait may sleep.
> >
> > Does anyone actually need to call it in a non-sleeping context or can the
> > documentation simply be fixed instead to avoid all the extra complexity ?
> >
> 
> It seems no one calls it in a non-sleeping context now, but we can provide it
> without much extra complexity, IMHO.  Also someone has complained it :
> 
>       http://marc.info/?t=124022846400003&r=1&w=2

That was 3 years ago :)

I say just fix the documentation.

thanks,

greg k-h
