Return-Path: <linux-kernel-owner+w=401wt.eu-S1758606AbYD2SFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606AbYD2SFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 14:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757884AbYD2SFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:05:01 -0400
Received: from outbound-mail-14.bluehost.com ([69.89.18.114]:54920 "HELO
	outbound-mail-14.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757838AbYD2SFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:05:00 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
Date: Tue, 29 Apr 2008 11:04:47 -0700
User-Agent: KMail/1.9.9
Cc: Dave Airlie <airlied@linux.ie>, Gabriel C <crazy@frugalware.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
References: <4815EEB4.2060509@frugalware.org> <alpine.DEB.0.82.0804282016440.5277@skynet.skynet.ie> <481678C6.7050400@googlemail.com>
In-Reply-To: <481678C6.7050400@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804291104.47687.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 28, 2008 6:24 pm Gabriel C wrote:
> Dave Airlie wrote:
> > On Mon, 28 Apr 2008, Gabriel C wrote:
> >> Hello ,
> >>
> >> are there any plans to add G33 / Q33 / Q35 chipsets support for the
> >> intelfb driver ? Is this driver still maintained ?
> >>
> >> ( I'm not really sure who maintains this driver so I've add peoples to
> >> CC I saw worked on it , I've also added Wang Zhenyu to CC while he added
> >> this support for AGP )
> >
> > Intel fb is unmaintained (well I've done trivial fixes in the past), and
> > I'd rather not add new chipset support to it.
> >
> > We are working (RH and Intel) on a new kernel modesetting layer which
> > will allow fbs integrated with proper memory management and support all
> > intel hw,
>
> Good news :)
>
> Are there any patch(es) / git tree one could try out ?

See the modesetting-101 branch of git://git.freedesktop.org/git/mesa/drm.  
It's a bit rough in spots but the i915 driver should be pretty close to 
feature parity with the Intel X driver at this point.

> > The main problem with intelfb is it trips up the userspace X drivers a
> > lot and generally break things..
>
> Really ? I didn't knew that.

Yeah it's been an ongoing source of problems...

Jesse
