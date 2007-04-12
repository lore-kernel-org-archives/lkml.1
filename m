Return-Path: <linux-kernel-owner+w=401wt.eu-S1422704AbXDLHXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422704AbXDLHXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 03:23:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422710AbXDLHXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 03:23:37 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:60286 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422704AbXDLHXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 03:23:36 -0400
Date: Thu, 12 Apr 2007 09:24:50 +0200
From: DervishD <lkml@dervishd.net>
To: Carlo Florendo <subscribermail@gmail.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
Message-ID: <20070412072450.GB24755@DervishD>
Mail-Followup-To: Carlo Florendo <subscribermail@gmail.com>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6> <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr> <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6> <461D84EB.7040207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <461D84EB.7040207@gmail.com>
User-Agent: Mutt/1.4.2.2i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Carlo :)

 * Carlo Florendo <subscribermail@gmail.com> dixit:
> Robert P. J. Day wrote:
> >  (in short, if i, the builder, explicitly choose *not* to add a
> >certain feature to my build, i think i have every right to expect that
> >some other part of my configuration isn't quietly going to put some
> >sub-choice of that feature back in behind my back.)
> 
> I agree with this.  However, if another feature actually depends on another 
> explicitly unselected feature, there should at least be a warning prompt 
> that such is the case.
> 
> It probably would be hard though to track all dependencies.

    I think that it wouldn't be that hard: some cases (like
CONFIG_EMBEDDED) are easy to spot, and the harder ones are going to bite
someone's arse sooner or later. If a bad dependency tracking doesn't
cause any harm, it doesn't need to be fixed right now, and if it bites,
it can be fixed before the next -stable release sees the light.
Fortunately, all dependencies (at least all that can cause harm if
untracked) will be spotted before the next minor kernel release.

    Hopefully...

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
