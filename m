Return-Path: <linux-kernel-owner+w=401wt.eu-S1761625AbYEEVCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761625AbYEEVCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755559AbYEEVBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:01:47 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:7756 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271AbYEEVBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:01:46 -0400
Message-ID: <481F7533.6070503@googlemail.com>
Date: Mon, 05 May 2008 22:59:31 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Dave Airlie <airlied@linux.ie>, Gabriel C <crazy@frugalware.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       Wang Zhenyu <zhenyu.z.wang@intel.com>
Subject: Re: intelfb and G33 / Q33 / Q35 chipsets support ?
References: <4815EEB4.2060509@frugalware.org> <4817A9D3.1030309@googlemail.com> <4817D687.8080201@googlemail.com> <200805050938.54453.jbarnes@virtuousgeek.org>
In-Reply-To: <200805050938.54453.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2008 20:52:38.0920 (UTC) FILETIME=[F44E9080:01C8AEF1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Tuesday, April 29, 2008 7:16 pm Gabriel C wrote:
>>>> See the modesetting-101 branch of
>>>> git://git.freedesktop.org/git/mesa/drm. It's a bit rough in spots but
>>>> the i915 driver should be pretty close to feature parity with the Intel
>>>> X driver at this point.
>>> Thx , I will try out the tree.
>> modesetting-101 does not compile on current git , NOPAGE_SIGBUS , nopage
>> and friends gone.
> 
> Yeah the DRM tree doesn't have a full kernel included, so it'll occasionally 
> be out-of-sync.  You could try a different kernel version (it almost always 
> works with the last stable release of Linux) or merging DRM master into 
> modesetting-101.  Assuming there are no conflicts that might also fix 
> things. :)

Hehe yes , I noticed :)

I've fixed myself local but it died later with:

WARNING: "i2c_bit_add_bus" [/work/git/drm/linux-core/i915.ko] undefined!

I didn't got time to investigate this one.

> 
> Jesse
> 

Gabriel
