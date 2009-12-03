Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZLCIWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZLCIWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 03:22:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZLCIWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 03:22:36 -0500
Received: from mail-pz0-f184.google.com ([209.85.222.184]:39301 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZLCIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 03:22:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bhv6EeG0oci8OO8pWM0cllO3vqqW3Ba2dW2gshJ5kznxfyCqmBoSuCAGoLEYbTSRpH
         RVSzNb5Eva41sEICur8QQnrAwkwH/7pQsIq9VygLGlxI5v+r5cTHtieZjTQ/S68Pp/ui
         ZTMPG/Vp0HHajpa9+vaeJepksdu8boc7pIm38=
Date: Thu, 3 Dec 2009 00:22:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: liu pf <kernelfans@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Should we use preempt_disable() in sleep_on_common()?
Message-ID: <20091203082237.GM9121@core.coreip.homeip.net>
References: <563a732e0912022249y1e831c6cv7f2d5d376b8a5f63@mail.gmail.com> <20091202230746.611f7fc5@infradead.org> <20091203071244.GI9121@core.coreip.homeip.net> <563a732e0912030015u7dc1cac2x2a2ae226c7107b4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <563a732e0912030015u7dc1cac2x2a2ae226c7107b4e@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 03, 2009 at 04:15:49PM +0800, liu pf wrote:
> On Thu, Dec 3, 2009 at 3:12 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > On Wed, Dec 02, 2009 at 11:07:46PM -0800, Arjan van de Ven wrote:
> >> On Thu, 3 Dec 2009 14:49:14 +0800
> >> liu pf <kernelfans@gmail.com> wrote:
> >>
> >> > Hi:
> >> >
> >> > I am puzzled with the following scenario. Could anyone enlighten me?
> >>
> >>
> >> sleep_on family of APIs is very racy and just cannot be used correctly;
> >> I'm not surprised that there's a preempt race in it, but trust me, it's
> >> not the biggest race... never ever use these APIs!!!
> >>
> >>
> >
> > BTW, why do we still have them? I checked couple and they don't seem to
> > be used...
> >
> > --
> > Dmitry
> >
> 
> Hi, what is the substitution for  sleep_on family of APIs? Any sample code?
> 

wait_event() and friends. Just look up any non-ancient driver.

-- 
Dmitry
