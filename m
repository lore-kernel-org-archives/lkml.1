Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662Ab0ANU2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab0ANU2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:28:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757679Ab0ANU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:28:09 -0500
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:43322 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757650Ab0ANU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:28:08 -0500
Date: Thu, 14 Jan 2010 15:28:03 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@linux.ie
Subject: Re: Linux 2.6.33-rc4
Message-ID: <20100114202803.GA1749@emergent.ellipticsemi.com>
Mail-Followup-To: Pekka Enberg <penberg@cs.helsinki.fi>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	airlied@linux.ie
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
 <84144f021001131303u56fa5470ua1c27dfef9f3de81@mail.gmail.com>
 <20100113133357.67f9df6d@jbarnes-piketon>
 <4B4E403C.1050509@cs.helsinki.fi>
 <20100113165530.2a7e7645@jbarnes-piketon>
 <4B4F6D5F.10008@cs.helsinki.fi>
 <20100114193118.GA1203@emergent.ellipticsemi.com>
 <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <84144f021001141218pa3cd71co76165532618145a8@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22:18 Thu 14 Jan     , Pekka Enberg wrote:
> On Thu, Jan 14, 2010 at 9:31 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> > diff --git a/drivers/gpu/drm/i915/intel_lvds.c b/drivers/gpu/drm/i915/intel_lvds.c
> > index f4b4aa2..4fb5911 100644
> > --- a/drivers/gpu/drm/i915/intel_lvds.c
> > +++ b/drivers/gpu/drm/i915/intel_lvds.c
> > @@ -914,7 +914,7 @@ static void intel_find_lvds_downclock(struct drm_device *dev,
> >        mutex_unlock(&dev->mode_config.mutex);
> >        if (temp_downclock < panel_fixed_mode->clock) {
> >                /* We found the downclock for LVDS. */
> > -               dev_priv->lvds_downclock_avail = 1;
> > +               dev_priv->lvds_downclock_avail = 0;
> >                dev_priv->lvds_downclock = temp_downclock;
> >                DRM_DEBUG_KMS("LVDS downclock is found in EDID. "
> >                                "Normal clock %dKhz, downclock %dKhz\n",
> 
> Should I try just this or combine it with Jesse's patch?

That's the only patch on top of mainline that I use -- it's been fixing
my problems since -rc1.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
