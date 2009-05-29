Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZE2Br1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZE2Br1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 21:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZE2BrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 21:47:19 -0400
Received: from kroah.org ([198.145.64.141]:33803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752816AbZE2BrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 21:47:19 -0400
Date: Thu, 28 May 2009 18:43:41 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core : fix request_firmware_nowait
Message-ID: <20090529014341.GA12295@kroah.com>
References: <1243004787-5362-1-git-send-email-tom.leiming@gmail.com> <20090522161016.36ef6f15@lxorguk.ukuu.org.uk> <d82e647a0905220826p378f6bb4vac9150343b5c3622@mail.gmail.com> <20090528201450.GA4043@kroah.com> <d82e647a0905281824kd98e5c9re22b4c43e68d341e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0905281824kd98e5c9re22b4c43e68d341e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 09:24:32AM +0800, Ming Lei wrote:
> 2009/5/29 Greg KH <greg@kroah.com>:
> > On Fri, May 22, 2009 at 11:26:16PM +0800, Ming Lei wrote:
> >> 2009/5/22 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> >> > On Fri, 22 May 2009 23:06:27 +0800
> >> > tom.leiming@gmail.com wrote:
> >> >
> >> >> From: Ming Lei <tom.leiming@gmail.com>
> >> >>
> >> >> request_firmware_nowait declares it can be called in non-sleep contexts,
> >> >> but kthead_run which is called by request_firmware_nowait may sleep.
> >> >
> >> > Does anyone actually need to call it in a non-sleeping context or can the
> >> > documentation simply be fixed instead to avoid all the extra complexity ?
> >> >
> >>
> >> It seems no one calls it in a non-sleeping context now, but we can provide it
> >> without much extra complexity, IMHO.  Also someone has complained it :
> >>
> >>       http://marc.info/?t=124022846400003&r=1&w=2
> >
> > That was 3 years ago :)
> 
> No, just one month ago, also the name of *_nowait is very misleading and only
> documentation fix seems not enough,  right?
> 
> http://marc.info/?t=124022846400003&r=1&w=2
> 
> 2009-04-20 Am I allowed to call request_firmware_nowait from an
> linux-ker John Hughes

Oops, sorry, you are right, I read the date wrong.

Anyway, I suggest just fixing the documentation, it's easier :)

thanks,

greg k-h
