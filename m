Return-Path: <linux-kernel-owner+w=401wt.eu-S933704AbYD3W1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933704AbYD3W1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762604AbYD3W0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:26:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:26325 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762682AbYD3W0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=wSECZ4+F33yRLpqhJVCfYzMWKoiPhIubosR50Xf8NyOetompQpqh8OTJLFQPAprtl3QjmqYAzrJX7KE7t+u+LLz+tXqaQv6CDWtRrjvpHmNGqywSb9YJxh7f2vugYXlP13luZKqKxMiBzOXvZ/mSHxrkmhtvpQjy2wPXAd8j7VA=
Date: Wed, 30 Apr 2008 18:26:45 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>, Jan Engelhardt <jengelh@gmx.de>,
       Richard Purdie <rpurdie@rpsys.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430222645.GB2629@anvil.corenet.prv>
References: <20080430185345.GA27224@elte.hu> <20080430150021.ZZRA012@mailhub.coreip.homeip.net> <20080430202013.GB14164@elte.hu> <20080430163924.ZZRA012@mailhub.coreip.homeip.net> <20080430212029.GA28813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430212029.GA28813@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:20:29PM +0200, Ingo Molnar wrote:
> 
> * Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> 
> > I thought the many years old rule for Linux kernel is to fix the 
> > issues properly and not turn kernel into patchwork of crappy code.
> 
> correct, except if that would mean breakage for users.
> 
> > If we want to fix the randconfi issue I'd rather revert commit 
> > 66242f7ec531953fbc2f4040c5ffe1f1ffe6c5c9 for now (they only thing it 
> > did was beautify menuconfig look) and wait for Kconfig to be fixed. It 
> > is not driver's task to track through all dependencies.
> 
> yep ... just dont export our internal crappiness to testers and users.
> 

So is there objections to reverting the commit above? This will
fix all drivers that are now depend on LEDS_CLASS bit not specify
NEW_LEDS dependency directly?

> i'm not suggesting this is your fault in any way - but nevertheless many 
> other subsystems have to deal with the same Kconfig issues and they 
> manage to limp along.
> 

I believe I see a steady stream of breakage for leds dependencies
from all subsystems.

-- 
Dmitry
