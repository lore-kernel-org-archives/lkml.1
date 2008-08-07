Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbYHGXlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbYHGXlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 19:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbYHGXlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 19:41:12 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:49255 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYHGXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 19:41:11 -0400
Date: Thu, 7 Aug 2008 16:41:10 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jean Delvare <khali@linux-fr.org>
cc: "D. Kelly" <user.kernel@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
In-Reply-To: <20080807181416.5de4ce6d@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0808071621060.22108@shell2.speakeasy.net>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
 <20080807131357.59399ddf@hyperion.delvare> <Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
 <20080807181416.5de4ce6d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Jean Delvare wrote:
> On Thu, 7 Aug 2008 09:01:35 -0700 (PDT), Trent Piepho wrote:
> > On Thu, 7 Aug 2008, Jean Delvare wrote:
> > > > One of the biggest reasons people choose to compile things from
> > > > cvs/svn/mercurial/etc. is because it gives them access to newer bug
> > > > fixes and support for things not yet present in the kernel source.  A
> > > > perfect example, the multiproto dvb driver tree.  Users wanting
> > > > support for dvb-s2 devices have to compile drivers outside of the
> > > > kernel because it's simply not available in the kernel and won't be
> > > > for some time.
> > >
> > > So basically you are telling that "thanks" to drivers being maintainers
> > > in external repositories, bugs are not fixed in the upstream kernel in
> > > a timely manner, and new features take more time to go there too? That
> > > must be the reason why kernel developers and users alike don't like
> > > external repositories in the first place.
> >
> > Code needs to get testing before it's put in the kernel.  How's that
> > supposed to happen if it's not made available outside the kernel tree
> > first?
>
> linux-next.

Expecting every developer to keep abreast of linux-next and the tens of
thousands of patches it gets just isn't realisitic.

The embedded platforms I develop on won't run linux-next.  Continuously
porting them to linux-next is simply impossible.  The man hours required to
do that would be staggering.

The pool of testers available to a driver that requires running linux-next
is going to be orders of magnitude less that a driver that can be compiled
out of tree against 2.6.19 to 2.6.27.

> Having I2C-specific options selectable under the Library menu would
> probably be even more confusing. However, it would be possible to do
> something similar under the I2C menu. Much like
> CONFIG_VIDEO_HELPER_CHIPS_AUTO does for the V4L subsystem:
> CONFIG_I2C_ALGOS_AUTO would default to Y and would hide I2C algo driver
> selection (as is the case in 2.6.26), changing it to N would present
> the old menu for users to select the aldo drivers manually (as was the
> case in 2.6.25.)

This seems perfectly reasonable to me.

> Which doesn't change my point that most people complaining about the
> change would rather merge their drivers in the upstream kernel.

Somtimes maintainers aren't interested in the drivers.....
