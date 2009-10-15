Return-Path: <linux-kernel-owner+w=401wt.eu-S1762813AbZJOPaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762813AbZJOPaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZJOPai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:30:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36892 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754569AbZJOPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:30:38 -0400
Date: Thu, 15 Oct 2009 16:31:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
Message-ID: <20091015163103.5e42fabe@lxorguk.ukuu.org.uk>
In-Reply-To: <4AD73E40.1010501@garzik.org>
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>
	<4AD711BC.2030409@garzik.org>
	<20091015160109.6d9353e8@lxorguk.ukuu.org.uk>
	<4AD73E40.1010501@garzik.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009 11:22:40 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> On 10/15/2009 11:01 AM, Alan Cox wrote:
> >> "no particular value" is highly subjective, and I think unprovable,
> >> without an exhaustive survey of userland programs interacting with
> >> kernel drivers.  Userland programs often interact with a -class- of
> >> drivers, expecting predictable behavior from a DoThisThing ioctl, with
> >> EINVAL or "other weird error code" returned intentionally.
> >>
> >> Changing the return codes seems quite unwise.
> >
> > We've changed lots of them to -ENOTTY over the past few years, nobody has
> > even noticed (you included ;))
> >
> > SuS says an unknown ioctl code returns -ENOTTY.
> 
> These are not unknown ioctls; they are ioctls that the driver author 
> close to implement rather than the default (ENOTTY).

That makes them ENOTTY please go and read the standards document.

EINVAL means you used an ioctl that is correct for the driver but that
for some reason the driver didn't like it.
