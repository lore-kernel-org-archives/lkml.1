Return-Path: <linux-kernel-owner+w=401wt.eu-S933930AbZLPUSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933930AbZLPUSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbZLPUSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:18:48 -0500
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:39640 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751244AbZLPUSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:18:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=DeBwTIsEksjaKw2ezD/T7I60HR2GsO4CGEx4Kh2ocfzBpMK8et1z6UbACucEMdOge7gk8Eg2ZCbeawdw8DwbZjXpMoEmH4Zidy30r6a92Uey3FMh3/7BFeWOfT0vu0lH;
Date: Wed, 16 Dec 2009 12:18:23 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Airlie <airlied@redhat.com>, Daniel Vetter <daniel@ffwll.ch>,
       Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes
 when ..."
Message-ID: <20091216121823.08b5f0a6@jbarnes-piketon>
In-Reply-To: <200912161453.12100.arnd@arndb.de>
References: <200912071830.14697.arnd@arndb.de>
	<20091214125024.77601d7e@jbarnes-piketon>
	<200912151051.44131.arnd@arndb.de>
	<200912161453.12100.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Dec 2009 14:53:11 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 15 December 2009, Arnd Bergmann wrote:
> > On Monday 14 December 2009, Jesse Barnes wrote:
> > > This patch removes the suspect portion of the dynamic clock
> > > control code.  Hopefully it'll be as stable as powersave=0 in
> > > your config (assuming powersave=0 works :).
> > 
> > Ok, great! The machine is still running  fine with powersave=0 so 
> > far. I'll try your patch after some more uptime.
> 
> It's working fine so far, no more crashes, but I supposed this
> effectively disables the power saving on my card again, right?

The patch just disables one (probably ineffective) power saving
feature.  So if things are working well for you with it I'll queue up a
revert patch.  I'm working on a better version of dynamic clock control
anyway.

-- 
Jesse Barnes, Intel Open Source Technology Center
