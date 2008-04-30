Return-Path: <linux-kernel-owner+w=401wt.eu-S933447AbYD3WrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933447AbYD3WrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbYD3WrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:47:08 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:48042 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756592AbYD3WrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=hWUc2ldx0JY5aU3cz/eVvoqmZiRahgQaRys7CavhTLJb50vRwScdsNx+ldK5cY4r9IPtbHwzh1xqNGQYroU/clV3prQriS9BcA8x4DmRG8PX26kZJwzp3r4x52KR9iIkpy2IVwjfvUYz8a4pCBK2f6tR1XCSs9hHI4xK7VPGQQY=
Date: Wed, 30 Apr 2008 18:47:01 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Jan Engelhardt <jengelh@gmx.de>,
       Richard Purdie <rpurdie@rpsys.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430224701.GC2629@anvil.corenet.prv>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net> <20080430212029.GA28813@elte.hu> <20080430222645.GB2629@anvil.corenet.prv> <20080430223828.GA31878@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430223828.GA31878@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 12:38:29AM +0200, Ingo Molnar wrote:
> 
> * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > > i'm not suggesting this is your fault in any way - but nevertheless 
> > > many other subsystems have to deal with the same Kconfig issues and 
> > > they manage to limp along.
> > 
> > I believe I see a steady stream of breakage for leds dependencies from 
> > all subsystems.
> 
> they limp along by adding "depends on NEW_LEDS". 99% of the users will 
> use some pre-cooked distro kernel where all these options are turned on, 
> so the flattening and coupling of the dependencies is not a real issue 
> in practice.

You still did not answer to the main question - do you think we should
revert the commit that actually introduced breakage in the sense that
anything depending on LEDS_CLASS should also add NEW_LEDS dependancy?
That will take care of the problem (as far as LEDs are concerned) for
_all_ subsystems and drivers at once.

-- 
Dmitry
