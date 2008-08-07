Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYHGQIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYHGQIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 12:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbYHGQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 12:08:16 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:45425 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbYHGQIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 12:08:15 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Aug 2008 12:08:15 EDT
Date: Thu, 7 Aug 2008 09:01:35 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Jean Delvare <khali@linux-fr.org>
cc: "D. Kelly" <user.kernel@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: [i2c] Problem with restricted I2C algorithms in kernel 2.6.26!
In-Reply-To: <20080807131357.59399ddf@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
 <20080807131357.59399ddf@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Jean Delvare wrote:
> > One of the biggest reasons people choose to compile things from
> > cvs/svn/mercurial/etc. is because it gives them access to newer bug
> > fixes and support for things not yet present in the kernel source.  A
> > perfect example, the multiproto dvb driver tree.  Users wanting
> > support for dvb-s2 devices have to compile drivers outside of the
> > kernel because it's simply not available in the kernel and won't be
> > for some time.
>
> So basically you are telling that "thanks" to drivers being maintainers
> in external repositories, bugs are not fixed in the upstream kernel in
> a timely manner, and new features take more time to go there too? That
> must be the reason why kernel developers and users alike don't like
> external repositories in the first place.

Code needs to get testing before it's put in the kernel.  How's that
supposed to happen if it's not made available outside the kernel tree
first?

Why does the kernel build system support building out of tree modules if no
one should do it?

Maybe an option to turn i2c algorithms on could do into the Library
Routines menu.  There are already options for things like the crc routines
here so they can be turned on if an out of tree driver needs them but
nothing in the kernel does.
