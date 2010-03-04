Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0CDHrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 02:47:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:41766 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753708Ab0CDHrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 02:47:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FESBgAkkFbfUyNAQKU7mkRDGlIbhIOOBUOq19vB
	ZELi8eqjBJ3D7r
Subject: Re: evdev keyboard driver stopped working after upgrading from
 Kernel  2.6.33-rc8 to 2.6.33 (official release)
From: Mike Galbraith <efault@gmx.de>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
References: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com>
	 <1267673633.6416.7.camel@marge.simson.net>
	 <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 04 Mar 2010 08:47:03 +0100
Message-Id: <1267688823.7029.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 08:22 +0100, Zeno Davatz wrote:
> On Thu, Mar 4, 2010 at 4:33 AM, Mike Galbraith <efault@gmx.de> wrote:
> > On Wed, 2010-03-03 at 21:45 +0100, Zeno Davatz wrote:
> 
> >> I am always updating to the latest rc Kernel Release, that Linus shares via Git.
> >>
> >> I also upgraded to the latest stable kernel version after rc-8, to
> >> 2.6.33. But since I am on 2.6.33 my Xorg evdev-Driver stopped working.
> >> I can hit any key on the keyboard, but nothing will happen. The mouse
> >> and the graphics are just fine and work well.
> >>
> >> I have an Asus Eeepc 1101HA, with Gentoo and the psb-kmod driver compiled.
> >>
> >> Xorg starts just fine, does not crash but the keyboard does not react.
> >>
> >> Everything worked fine on 2.6.33-rc8.
> >>
> >> Any hints what changed from 2.6.33-rc8 to 2.6.33 stable that made my
> >> keyboard stop reacting?
> >>
> >> Let me know and I will test.
> >
> > I don't see any obvious candidates rc8->final.  There's _very_ little
> > for input.
> >
> > On the bright side, there are only 225 commits, so a bisection should be
> > almost painless.  That's probably your best bet for rapid resolution.
> 
> Is there a possibility that something changed between rc2 and final,
> something that would concern the evdev driver or the keyboard input?
> It seems that /dev/input/event5 where the keyboard is found does not
> pass anything on to Xorg.

Dunno about rc2, I looked rc8->final.  Not much there.

> I did not change anything else on my system except upgrading the kernel.

I'd bisect it asap.

	-Mike


