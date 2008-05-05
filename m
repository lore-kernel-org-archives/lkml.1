Return-Path: <linux-kernel-owner+w=401wt.eu-S1761503AbYEEVLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761503AbYEEVLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758247AbYEEVLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:11:25 -0400
Received: from outbound-mail-127.bluehost.com ([67.222.38.27]:54263 "HELO
	outbound-mail-127.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756757AbYEEVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:11:25 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
Date: Mon, 5 May 2008 14:11:02 -0700
User-Agent: KMail/1.9.9
Cc: Dave Airlie <airlied@linux.ie>, Gabriel C <crazy@frugalware.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
References: <4815EEB4.2060509@frugalware.org> <200805050938.54453.jbarnes@virtuousgeek.org> <481F7533.6070503@googlemail.com>
In-Reply-To: <481F7533.6070503@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051411.03047.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 05, 2008 1:59 pm Gabriel C wrote:
> Jesse Barnes wrote:
> > On Tuesday, April 29, 2008 7:16 pm Gabriel C wrote:
> >>>> See the modesetting-101 branch of
> >>>> git://git.freedesktop.org/git/mesa/drm. It's a bit rough in spots but
> >>>> the i915 driver should be pretty close to feature parity with the
> >>>> Intel X driver at this point.
> >>>
> >>> Thx , I will try out the tree.
> >>
> >> modesetting-101 does not compile on current git , NOPAGE_SIGBUS , nopage
> >> and friends gone.
> >
> > Yeah the DRM tree doesn't have a full kernel included, so it'll
> > occasionally be out-of-sync.  You could try a different kernel version
> > (it almost always works with the last stable release of Linux) or merging
> > DRM master into modesetting-101.  Assuming there are no conflicts that
> > might also fix things. :)
>
> Hehe yes , I noticed :)
>
> I've fixed myself local but it died later with:
>
> WARNING: "i2c_bit_add_bus" [/work/git/drm/linux-core/i915.ko] undefined!
>
> I didn't got time to investigate this one.

That can happen if the i2c stuff isn't loaded before the DRM module.  Usually 
depmod picks this up, but if you have multiple versions lying around it may 
pick the wrong one.  You can still load i2c-core etc. by hand though, and 
then 'insmod i915 modeset=1'.

Jesse

