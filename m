Return-Path: <linux-kernel-owner+w=401wt.eu-S1752797AbYEEW7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797AbYEEW7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760506AbYEEW6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:58:45 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:32730 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbYEEW6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:58:40 -0400
Message-ID: <481F9064.4080900@googlemail.com>
Date: Tue, 06 May 2008 00:55:32 +0200
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
References: <4815EEB4.2060509@frugalware.org> <200805050938.54453.jbarnes@virtuousgeek.org> <481F7533.6070503@googlemail.com> <200805051411.03047.jbarnes@virtuousgeek.org>
In-Reply-To: <200805051411.03047.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 May 2008 22:48:40.0801 (UTC) FILETIME=[29E94D10:01C8AF02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, May 05, 2008 1:59 pm Gabriel C wrote:
>> Jesse Barnes wrote:
>>> On Tuesday, April 29, 2008 7:16 pm Gabriel C wrote:
>>>>>> See the modesetting-101 branch of
>>>>>> git://git.freedesktop.org/git/mesa/drm. It's a bit rough in spots but
>>>>>> the i915 driver should be pretty close to feature parity with the
>>>>>> Intel X driver at this point.
>>>>> Thx , I will try out the tree.
>>>> modesetting-101 does not compile on current git , NOPAGE_SIGBUS , nopage
>>>> and friends gone.
>>> Yeah the DRM tree doesn't have a full kernel included, so it'll
>>> occasionally be out-of-sync.  You could try a different kernel version
>>> (it almost always works with the last stable release of Linux) or merging
>>> DRM master into modesetting-101.  Assuming there are no conflicts that
>>> might also fix things. :)
>> Hehe yes , I noticed :)
>>
>> I've fixed myself local but it died later with:
>>
>> WARNING: "i2c_bit_add_bus" [/work/git/drm/linux-core/i915.ko] undefined!
>>
>> I didn't got time to investigate this one.
> 
> That can happen if the i2c stuff isn't loaded before the DRM module.  Usually 
> depmod picks this up, but if you have multiple versions lying around it may 
> pick the wrong one.  You can still load i2c-core etc. by hand though, and 
> then 'insmod i915 modeset=1'.

Right , got it to load at least that way.

It does not work here , with modeset=1 box hangs when staring X , without box magically reboots :-)

I guess I need to test it on 2.6.25 sometimes this week.

> 
> Jesse
> 
> 

Gabriel
