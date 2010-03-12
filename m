Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab0CLRkH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:40:07 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:56830 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933743Ab0CLRkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:40:05 -0500
Subject: Re: [PATCH] backlight: provide sysfs percent brightness attribute
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20100312173341.GA4931@khazad-dum.debian.net>
References: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
	 <20100312173341.GA4931@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Mar 2010 09:39:45 -0800
Message-ID: <1268415585.1625.13.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-12 at 14:33 -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 12 Mar 2010, H Hartley Sweeten wrote:
> > It's usually more convenient to set the backlight brightness
> > as a 'percent' of total brightness rather than using the raw
> > 'brightness' value.
> 
> Well, that scale is often not linear, so you are not dealing with fractions
> of the effective brightness, just with fractions of an arbritary scale
> exported by the backend driver.  Much of the "usefulness" of a "percent"
> scale dies right there.

This patch does nothing to address that though.

I agree this is a userland issue and having two interfaces to the kernel
to do the same thing is not a good idea in general.

So no, I'm not going to take that patch, sorry.

Cheers,

Richard

