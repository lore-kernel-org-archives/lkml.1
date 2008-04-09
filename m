Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYDIRX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYDIRX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYDIRXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:23:49 -0400
Received: from fairlite.demon.co.uk ([80.176.228.186]:60252 "EHLO
	fairlite.demon.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYDIRXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:23:49 -0400
Subject: Re: DRM modesetting & sysfs
From: Alan Hourihane <alanh@fairlite.demon.co.uk>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jakob Bornecrantz <wallbraker@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200804090934.37219.jbarnes@virtuousgeek.org>
References: <200804081317.43712.jbarnes@virtuousgeek.org>
	 <200804090817.02836.jbarnes@virtuousgeek.org>
	 <1207757730.14588.381.camel@localhost>
	 <200804090934.37219.jbarnes@virtuousgeek.org>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 18:23:46 +0100
Message-Id: <1207761826.14588.390.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-09 at 09:34 -0700, Jesse Barnes wrote:
> On Wednesday, April 09, 2008 9:15 am Alan Hourihane wrote:
> > On Wed, 2008-04-09 at 08:17 -0700, Jesse Barnes wrote:
> > > On Wednesday, April 09, 2008 1:57 am Jakob Bornecrantz wrote:
> > > > I was going to suggest that you plug it into the hotplug_stage_two
> > > > function but it looks like you have already done that. Things might be
> > > > routed differently now then since the last time I looked at the code,
> > > > are you sure that stage_two is being run?
> > >
> > > I'll have to check, I'm not sure I'm even getting interrupts...
> >
> > Jesse,
> >
> > Is this i915 or i945/i965 you are testing on ??
> 
> I've been testing on my i915 based laptop, haven't tried my other systems 
> yet...

With VGA (i.e. ADPA) output ?

If so, that's the problem. From what I can tell of i915 docs, they only
support hotplug for SDVO devices only, so that's how it's coded up at
the moment. For i945/i965 it can go the whole hog.

Alan.

