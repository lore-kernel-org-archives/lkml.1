Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbYEEQjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbYEEQjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 12:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYEEQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 12:39:08 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:43519 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755180AbYEEQjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 12:39:07 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gabriel C <nix.or.die@googlemail.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
Date: Mon, 5 May 2008 09:38:54 -0700
User-Agent: KMail/1.9.9
Cc: Dave Airlie <airlied@linux.ie>, Gabriel C <crazy@frugalware.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
References: <4815EEB4.2060509@frugalware.org> <4817A9D3.1030309@googlemail.com> <4817D687.8080201@googlemail.com>
In-Reply-To: <4817D687.8080201@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805050938.54453.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 7:16 pm Gabriel C wrote:
> >> See the modesetting-101 branch of
> >> git://git.freedesktop.org/git/mesa/drm. It's a bit rough in spots but
> >> the i915 driver should be pretty close to feature parity with the Intel
> >> X driver at this point.
> >
> > Thx , I will try out the tree.
>
> modesetting-101 does not compile on current git , NOPAGE_SIGBUS , nopage
> and friends gone.

Yeah the DRM tree doesn't have a full kernel included, so it'll occasionally 
be out-of-sync.  You could try a different kernel version (it almost always 
works with the last stable release of Linux) or merging DRM master into 
modesetting-101.  Assuming there are no conflicts that might also fix 
things. :)

Jesse
