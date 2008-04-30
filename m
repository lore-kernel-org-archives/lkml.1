Return-Path: <linux-kernel-owner+w=401wt.eu-S933974AbYD3WWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974AbYD3WWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934185AbYD3WVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:21:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:11821 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbYD3WVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=G6zArMnMIttJkoeulknUDtdxZYVXDrloVYCIx/A7uBVnaqErCaRpPqDzNAOBHhXvZR/zqGDs7jwaU4H+0HQ6cyc1tafhwUyWzsBd30qFB8OMmoqSdipXclirSGb+15P634QSzA6g4noojKRn89TTYHkfTja0u6hDLpluLWNqE7Y=
Date: Wed, 30 Apr 2008 18:21:04 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430222104.GA2629@anvil.corenet.prv>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <Pine.LNX.4.64.0804302232060.30555@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804302232060.30555@scrub.home>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 10:56:05PM +0200, Roman Zippel wrote:
> Hi,
> 
> On Wed, 30 Apr 2008, Ingo Molnar wrote:
> 
> > > Thank you Ingo. Isn't this a Kconfig issue though? I know that Roman 
> > > is not willing to fix SELECT to evaluate the whole dependency chain, 
> > > but in this case it is "depens on" that does not evaluate properly...
> > 
> > yes and no. It can be fixed in Kconfig but i'm not going to flame yet 
> > another person about long-existing unfixed infrastructure bugs ;-)
> 
> You don't have to, because this simply is no infrastructure bug...
> Don't blame Kconfig for abusing select for something it was never 
> intendend for. There is no bug!
>

That is all fine and dandy except that apanel does not select LEDs, it
depends on LEDS_CLASS.
 
> In this case there is now a mixture of depends and selects on leds. First 
> decide whether led support should be automatically included or the driver 
> is only available when led support is enabled. In the first case it's 
> probably better to create LEDS_SUPPORT, which then again selects 
> everything necessary.
>

The decision is made, the driver depends on LEDs except that it is not
working.

-- 
Dmitry
