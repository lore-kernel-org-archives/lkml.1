Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYHGQOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYHGQOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYHGQOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:14:30 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:45986 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbYHGQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:14:29 -0400
Date: Thu, 7 Aug 2008 18:14:16 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "D. Kelly" <user.kernel@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080807181416.5de4ce6d@hyperion.delvare>
In-Reply-To: <Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
	<20080807131357.59399ddf@hyperion.delvare>
	<Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

On Thu, 7 Aug 2008 09:01:35 -0700 (PDT), Trent Piepho wrote:
> On Thu, 7 Aug 2008, Jean Delvare wrote:
> > > One of the biggest reasons people choose to compile things from
> > > cvs/svn/mercurial/etc. is because it gives them access to newer bug
> > > fixes and support for things not yet present in the kernel source.  A
> > > perfect example, the multiproto dvb driver tree.  Users wanting
> > > support for dvb-s2 devices have to compile drivers outside of the
> > > kernel because it's simply not available in the kernel and won't be
> > > for some time.
> >
> > So basically you are telling that "thanks" to drivers being maintainers
> > in external repositories, bugs are not fixed in the upstream kernel in
> > a timely manner, and new features take more time to go there too? That
> > must be the reason why kernel developers and users alike don't like
> > external repositories in the first place.
> 
> Code needs to get testing before it's put in the kernel.  How's that
> supposed to happen if it's not made available outside the kernel tree
> first?

linux-next.

> Why does the kernel build system support building out of tree modules if no
> one should do it?

I guess it can be convenient at times. But people doing that shouldn't
dare to complain that everything isn't perfect for them.

> Maybe an option to turn i2c algorithms on could do into the Library
> Routines menu.  There are already options for things like the crc routines
> here so they can be turned on if an out of tree driver needs them but
> nothing in the kernel does.

Having I2C-specific options selectable under the Library menu would
probably be even more confusing. However, it would be possible to do
something similar under the I2C menu. Much like
CONFIG_VIDEO_HELPER_CHIPS_AUTO does for the V4L subsystem:
CONFIG_I2C_ALGOS_AUTO would default to Y and would hide I2C algo driver
selection (as is the case in 2.6.26), changing it to N would present
the old menu for users to select the aldo drivers manually (as was the
case in 2.6.25.)

Which doesn't change my point that most people complaining about the
change would rather merge their drivers in the upstream kernel.

-- 
Jean Delvare
