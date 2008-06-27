Return-Path: <linux-kernel-owner+w=401wt.eu-S1762786AbYF0Tn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762786AbYF0Tn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762382AbYF0TnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:43:05 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:49887 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762291AbYF0TnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:43:04 -0400
Date: Fri, 27 Jun 2008 22:40:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: -tip build failure: No rule to make target
	`/etc/sound/dsp001.ld'
Message-ID: <20080627194047.GD4306@cs181140183.pp.htv.fi>
References: <19f34abd0806271225q409dfa51haca8de843eeec76f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <19f34abd0806271225q409dfa51haca8de843eeec76f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 09:25:05PM +0200, Vegard Nossum wrote:
> Hi,
> 
> I was just building a randconfig in tip/master and hit this:
> 
> make[2]: *** No rule to make target `/etc/sound/dsp001.ld', needed by
> `sound/oss/pss_boot.h'.  Stop.
> 
> It seems to be done like this on purpose, but it breaks randconfig
> builds. Is this something that should be using firmware API?
> 
> I'm attaching the config. Please forward this in the right direction,
> if such a thing exists.

It's your fault - compile errors with CONFIG_STANDALONE=n are expected.

> Vegard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

