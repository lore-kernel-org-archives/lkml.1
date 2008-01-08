Return-Path: <linux-kernel-owner+w=401wt.eu-S1758048AbYAHRzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbYAHRzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbYAHRzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:55:07 -0500
Received: from main.gmane.org ([80.91.229.2]:39852 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754769AbYAHRzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:55:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: The ext3 way of journalling
Date: Tue, 8 Jan 2008 17:52:50 +0000 (UTC)
Message-ID: <slrnfo7e3i.c37.tuomov@jolt.modeemi.cs.tut.fi>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <20080108164847.GA16462@skl-net.de>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-01-08, Andre Noll <maan@systemlinux.org> wrote:
> Use tune2fs to deactivate checking.

So, a workaround is the answer to a clear bug. Typical FOSS.

> Modify the init scripts or use another distro.

Another typical FOSS answer. "You have the source, you can fix it."
With what time?

> Don't use udev then. Good old static dev works fine if you have a fixed
> set of devices.

It doesn't, with the unpredictable SCSI mapping insanity.

> You're using the sil3112 driver? Edit its blacklist and remove the
> entry for your drive. That gives you the usual speed.

Recompiling? No thanks. Compiling the Linux kernel is too painful.

> Check your tool-chain. Many people compile recent kernels with no problems.

And recompile and recompile and recompile ad infinitum, because always
some option was missing or wrong, there being far too many of them and
hidden all over the place.

> Nobody forces you to use udev. Moreover, you can write your own udev
> rules that match your expectations.

See above on having time to learn over-cryptic systems.

> You're not ranting about Linux but about your Distro. Complain on
> the corresponding distro-specific mailing list, use another distro
> and and stop whining.

I don't use a distro kernel. I use a kernel I compiled myself over
two years ago. I have tried compiling newer ones, but it's too much
work to get all the options right. And then there's the problem that
the "good" driver for my SATA disk may not be there anymore in the
latest kernels, and so on.

-- 
Tuomo

