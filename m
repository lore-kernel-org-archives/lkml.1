Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYHHRwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYHHRwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 13:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYHHRwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 13:52:09 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:52510 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYHHRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 13:52:08 -0400
Date: Fri, 8 Aug 2008 10:52:05 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jean Delvare <khali@linux-fr.org>
cc: "D. Kelly" <user.kernel@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
In-Reply-To: <20080808113753.03f49efe@hyperion.delvare>
Message-ID: <Pine.LNX.4.58.0808081037080.3151@shell2.speakeasy.net>
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
 <20080807131357.59399ddf@hyperion.delvare> <Pine.LNX.4.58.0808070851310.10341@shell4.speakeasy.net>
 <20080807181416.5de4ce6d@hyperion.delvare> <Pine.LNX.4.58.0808071621060.22108@shell2.speakeasy.net>
 <20080808113753.03f49efe@hyperion.delvare>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Jean Delvare wrote:
> On Thu, 7 Aug 2008 16:41:10 -0700 (PDT), Trent Piepho wrote:
> > Expecting every developer to keep abreast of linux-next and the tens of
> > thousands of patches it gets just isn't realisitic.
> >
> > The embedded platforms I develop on won't run linux-next.  Continuously
> > porting them to linux-next is simply impossible.  The man hours required to
> > do that would be staggering.
>
> Once again a "believe me it's impossible" without any good reason
> given. I fail to see why embedded platforms would be any different from
> other platforms or subsystem trees. Please enlighten me.

Because they usually require lots of additional patches that aren't in the
kernel.  Sometimes embedded developers try to get these patches into the
mainline kernel, but some maintainers aren't interested in accepting
patches that don't appear to be useful to desktop users.

> > The pool of testers available to a driver that requires running linux-next
> > is going to be orders of magnitude less that a driver that can be compiled
> > out of tree against 2.6.19 to 2.6.27.
>
> Except that distributions start packaging linux-next, while in general
> they don't package out-of-tree versions of packages that are also
> available in the kernel tree. If the v4l-dvb tip was in linux-next (it

Sure they do.  There are packages of the latest v4l-dvb, nvidia and ATI
drivers, and more.  There is even a system, DKMS, used to allow kernel
module source packages to be installed and automatically rebuilt for new
kernels.

You can install and run a new module without even rebooting.  Installing
linux next is quite a bit more complex.  Users won't test your driver if
they have to install a new kernel for every revision.

It's a nightmare for development too.  I can't develop the entire kernel,
it's too big and there are too many changes.  If my driver has become
unstable, is it something I did or one of the 20,000 patches that have
appeared in linux-next?  Like Mike said, one needs a stable platform to
develop on.
