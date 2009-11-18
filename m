Return-Path: <linux-kernel-owner+w=401wt.eu-S1758079AbZKRRjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079AbZKRRjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZKRRjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:39:36 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:62192 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044AbZKRRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eH5KP4bMh1qcIA24KHfU9DulMVHcQXTnuJcJkw5H/1plwJE2DNwtDItEQHMw364xCL
         5nm8h+gWMizQbk1OpMUtvh4uhYCkAME2smN7epvFPZml6cNk2bynVV1ZklOmAC7ZGypz
         9F6OAEkLG3/LqK4d1i4koyoBYQBaitv59w7EY=
Date: Wed, 18 Nov 2009 09:39:34 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul Parsons <lost.distance@yahoo.com>, linux-input@vger.kernel.org,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, linux-kernel@vger.kernel.org,
       Dirk@Opfer-Online.de, arminlitzel@web.de, metan@ucw.cz,
       thommycheck@gmail.com, linux-arm-kernel@lists.infradead.org,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
Message-ID: <20091118173934.GA4458@core.coreip.homeip.net>
References: <E1NAYJo-00016g-PW@pih-relay04.plus.net> <20091118172849.GD25150@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118172849.GD25150@elf.ucw.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 06:28:49PM +0100, Pavel Machek wrote:
> On Wed 2009-11-18 00:22:41, Paul Parsons wrote:
> > > Does pressure actually work as expected -- that is not inverted?
> > > Because I need this patch on spitz...  but it may break your
> > > machine...
> > 
> > You are right, the pressure values were being inverted on my hx4700.
> > Pressing hard generates somewhat lower Rt values than pressing lightly.
> > 
> > Since typical hx4700 Rt values are close to (pressure_max/2) anyway,
> > the inverted and non-inverted values were not very different.
> > For example:
> > 
> > Rt      ts->pressure_max-Rt
> > 599     425
> > 562     462
> > 588     436
> > 570     454
> > 
> > So by all means submit your ads7846.c patch; it will not break hx4700.
> 
> Dmitry, those pressure values are reverted on more than one machine,
> and we do not have anyone reporting it works ok for them. Can we
> perhaps just.... fix it?

OK, so we have 4 instances where pressure is inverted and nobody wants
to come out with a non-inverted example... I'll queue for .33 then - .32
it too close to the release.

-- 
Dmitry
