Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZKRRqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZKRRqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZKRRqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:46:51 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:57294 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbZKRRqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:46:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Vp0r8La/LB8omCIjDBovKeVM/NgNIDyiSGKCmzI6hXv3DCd/RKqVqMXa87SJtzcPY8
         ziPZG9519qo/sl8a+iIJWMT6YIeq+ErTU2TTt9/DZMnyUHOYtlg39IfoGW8kTeyszEHh
         R6n3La12QOTOgvT5vyJSsxKc7V2xoSGd1VP4Q=
Date: Wed, 18 Nov 2009 09:46:49 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Paul Parsons <lost.distance@yahoo.com>, linux-input@vger.kernel.org,
       rpurdie@rpsys.net, lenz@cs.wisc.edu, linux-kernel@vger.kernel.org,
       Dirk@Opfer-Online.de, arminlitzel@web.de, metan@ucw.cz,
       thommycheck@gmail.com, linux-arm-kernel@lists.infradead.org,
       dbaryshkov@gmail.com, omegamoon@gmail.com, eric.y.miao@gmail.com,
       utx@penguin.cz
Subject: Re: [PATCH] hx4700: fix hx4700 touchscreen pressure values
Message-ID: <20091118174649.GB4458@core.coreip.homeip.net>
References: <E1NAYJo-00016g-PW@pih-relay04.plus.net> <20091118172849.GD25150@elf.ucw.cz> <20091118173934.GA4458@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118173934.GA4458@core.coreip.homeip.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 09:39:34AM -0800, Dmitry Torokhov wrote:
> On Wed, Nov 18, 2009 at 06:28:49PM +0100, Pavel Machek wrote:
> > On Wed 2009-11-18 00:22:41, Paul Parsons wrote:
> > > > Does pressure actually work as expected -- that is not inverted?
> > > > Because I need this patch on spitz...  but it may break your
> > > > machine...
> > > 
> > > You are right, the pressure values were being inverted on my hx4700.
> > > Pressing hard generates somewhat lower Rt values than pressing lightly.
> > > 
> > > Since typical hx4700 Rt values are close to (pressure_max/2) anyway,
> > > the inverted and non-inverted values were not very different.
> > > For example:
> > > 
> > > Rt      ts->pressure_max-Rt
> > > 599     425
> > > 562     462
> > > 588     436
> > > 570     454
> > > 
> > > So by all means submit your ads7846.c patch; it will not break hx4700.
> > 
> > Dmitry, those pressure values are reverted on more than one machine,
> > and we do not have anyone reporting it works ok for them. Can we
> > perhaps just.... fix it?
> 
> OK, so we have 4 instances where pressure is inverted and nobody wants
> to come out with a non-inverted example... I'll queue for .33 then - .32
> it too close to the release.
> 

Btw, could you send me the latest version of your patch please?

-- 
Dmitry
