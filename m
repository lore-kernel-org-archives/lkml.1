Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab0BBMDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 07:03:34 -0500
Received: from nox.protox.org ([88.191.38.29]:57617 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442Ab0BBMDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 07:03:32 -0500
Date: Tue, 2 Feb 2010 12:59:13 +0100
From: Jerome Glisse <glisse@freedesktop.org>
To: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: [crash, PATCH] Revert "drm/radeon/kms: move radeon KMS on/off
 switch out of staging."
Message-ID: <20100202115913.GB10289@localhost.localdomain>
References: <alpine.DEB.2.00.1002010215530.15366@skynet.skynet.ie>
 <alpine.DEB.2.00.1002010253120.15366@skynet.skynet.ie>
 <20100202081727.GA6788@elte.hu>
 <20100202085820.GA9586@raptus.dandreoli.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202085820.GA9586@raptus.dandreoli.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 09:58:20AM +0100, Domenico Andreoli wrote:
> On Tue, Feb 02, 2010 at 09:17:27AM +0100, Ingo Molnar wrote:
> > 
> > * Dave Airlie <airlied@linux.ie> wrote:
> > 
> > > > Hi Linus,
> > > > 
> > > > Please pull the 'drm-linus' branch from
> > > > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus
> > > > 
> > 
> > FYI, this drm pull into mainline has triggered quick boot crashes in -tip 
> > testing (even with the above fix applied), on an Athlon64 whitebox PC with:
> 
> boot broke also here where unfortunately i have not a serial line
> to see what's happening. anyway disabling KMS restores a working
> 2.6.33-rc6-00072-gab65832 kernel.  here is the broken config.
> 
> in the next days i should be able to test it with a RV770.
> 
> >  01:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 [Radeon X300 (PCIE)]
> >  01:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV515 [Radeon X1300]
> 01:00.1 Display controller: ATI Technologies Inc RV515 [Radeon X1300] (Secondary)
> 
> 

Can you boot in runlevel 3 and with radeon.modeset=0. Then modprobe radeon modeset=1
(you might need to rmmod first), this should allow you capture dmesg log with the failure.
(Do the modprobe/rmmod through ssh as you won't have a console in the process).

Note that here RV515 works like a charm :)

Cheers,
Jerome
