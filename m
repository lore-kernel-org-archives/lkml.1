Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYDIRlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYDIRlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753079AbYDIRlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:41:17 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:50449 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752575AbYDIRlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:41:16 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: Re: DRM modesetting & sysfs
Date: Wed, 9 Apr 2008 10:39:08 -0700
User-Agent: KMail/1.9.9
Cc: Jakob Bornecrantz <wallbraker@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200804081317.43712.jbarnes@virtuousgeek.org> <200804090934.37219.jbarnes@virtuousgeek.org> <1207761826.14588.390.camel@localhost>
In-Reply-To: <1207761826.14588.390.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804091039.09050.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 09, 2008 10:23 am Alan Hourihane wrote:
> On Wed, 2008-04-09 at 09:34 -0700, Jesse Barnes wrote:
> > On Wednesday, April 09, 2008 9:15 am Alan Hourihane wrote:
> > > On Wed, 2008-04-09 at 08:17 -0700, Jesse Barnes wrote:
> > > > On Wednesday, April 09, 2008 1:57 am Jakob Bornecrantz wrote:
> > > > > I was going to suggest that you plug it into the hotplug_stage_two
> > > > > function but it looks like you have already done that. Things might
> > > > > be routed differently now then since the last time I looked at the
> > > > > code, are you sure that stage_two is being run?
> > > >
> > > > I'll have to check, I'm not sure I'm even getting interrupts...
> > >
> > > Jesse,
> > >
> > > Is this i915 or i945/i965 you are testing on ??
> >
> > I've been testing on my i915 based laptop, haven't tried my other systems
> > yet...
>
> With VGA (i.e. ADPA) output ?
>
> If so, that's the problem. From what I can tell of i915 docs, they only
> support hotplug for SDVO devices only, so that's how it's coded up at
> the moment. For i945/i965 it can go the whole hog.

Ah, maybe that's it, yeah I'm using VGA via ADPA.  I don't see any IIR or 
PIPEASTAT bits set when I plug in the display, so I guess we're stuck with 
manually probing on these devices.

Thanks,
Jesse
