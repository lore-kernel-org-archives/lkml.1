Return-Path: <linux-kernel-owner+w=401wt.eu-S1762411AbYF0TnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762411AbYF0TnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbYF0Tmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:42:51 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:57036 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbYF0Tmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:42:50 -0400
Date: Fri, 27 Jun 2008 21:42:43 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: -tip build failure: No rule to make target `/etc/sound/dsp001.ld'
Message-ID: <20080627194243.GA19115@uranus.ravnborg.org>
References: <19f34abd0806271225q409dfa51haca8de843eeec76f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0806271225q409dfa51haca8de843eeec76f@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
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

config STANDALONE
        bool "Select only drivers that don't need compile-time external firmware" if EXPERIMENTAL
        default y
        help
          Select this option if you don't have magic firmware for drivers that
          need it.

          If unsure, say Y.

And you have this set to 'n' so it is expected.

	Sam
