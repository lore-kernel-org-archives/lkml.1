Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbYAHSHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbYAHSHs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750716AbYAHSHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:07:40 -0500
Received: from hs-out-0708.google.com ([64.233.178.247]:48038 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbYAHSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:07:39 -0500
Message-ID: <1a9da18c0801081007q1ed8ce04x7a78e880ee5bcac7@mail.gmail.com>
Date: Tue, 8 Jan 2008 10:07:37 -0800
From: "=?UTF-8?Q?Masoud_Sharbiani?=
	=?UTF-8?Q?_\"=D9=85=D8=B3=D8=B9=D9=88=D8=AF_?=
	=?UTF-8?Q?=D8=B4=D8=B1=D8=A8=DB=8C=D8=A7=D9=86=DB=8C\"?=" 
	<masouds@masoud.ir>
To: "Tuomo Valkonen" <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080108164847.GA16462@skl-net.de>
	 <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/8/08, Tuomo Valkonen <tuomov@iki.fi> wrote:
> On 2008-01-08, Andre Noll <maan@systemlinux.org> wrote:
> > Use tune2fs to deactivate checking.
>
> So, a workaround is the answer to a clear bug. Typical FOSS.

It isn't a bug. It is a feature; Think about silent corruption that
may damage your filesystem; Only an FSCK can see how much of damage is
done and fix it. Journaling will help you to a degree, but not all the
way.

> > Modify the init scripts or use another distro.
>
> Another typical FOSS answer. "You have the source, you can fix it."
> With what time?

heh, the way I look at it, you either have the time, or money. Use one
and get rid of your problem. If you have them and aren't willing to
commit to fix your problem, maybe your problem isn't important enough
to you. If you have no time and no money, ranting here doesn't help
you either.

cheers,
Masoud

> > Don't use udev then. Good old static dev works fine if you have a fixed
> > set of devices.
>
> It doesn't, with the unpredictable SCSI mapping insanity.
>
> > You're using the sil3112 driver? Edit its blacklist and remove the
> > entry for your drive. That gives you the usual speed.
>
> Recompiling? No thanks. Compiling the Linux kernel is too painful.
>
> > Check your tool-chain. Many people compile recent kernels with no problems.
>
> And recompile and recompile and recompile ad infinitum, because always
> some option was missing or wrong, there being far too many of them and
> hidden all over the place.
>
> > Nobody forces you to use udev. Moreover, you can write your own udev
> > rules that match your expectations.
>
> See above on having time to learn over-cryptic systems.
>
> > You're not ranting about Linux but about your Distro. Complain on
> > the corresponding distro-specific mailing list, use another distro
> > and and stop whining.
>
> I don't use a distro kernel. I use a kernel I compiled myself over
> two years ago. I have tried compiling newer ones, but it's too much
> work to get all the options right. And then there's the problem that
> the "good" driver for my SATA disk may not be there anymore in the
> latest kernels, and so on.
>
> --
> Tuomo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
